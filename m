Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3H0SQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:16:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45171 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188Ab3H0SQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:16:10 -0400
Message-ID: <1377627362.6337.40.camel@joe-AO722>
Subject: Re: [PATCHv2 1/2] dev-core: fix build break when DEBUG is enabled
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@akamai.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 27 Aug 2013 11:16:02 -0700
In-Reply-To: <521CE2C9.1010002@akamai.com>
References: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
	 <1377620432.6337.12.camel@joe-AO722> <521CE2C9.1010002@akamai.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 13:32 -0400, Jason Baron wrote:
> On 08/27/2013 12:20 PM, Joe Perches wrote:
> > On Tue, 2013-08-27 at 17:47 +0300, Dmitry Kasatkin wrote:
> >> When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
> >> structures even when CONFIG_DYNAMIC_DEBUG is not defined.
> >> It leads to build break.
> >> For example, when I try to use dev_dbg_ratelimited in USB code and
> >> CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:
> > Jason?
> >
> > Seems mostly sensible to me but I think the first check
> > needs to be
> >
> > #if defined(CONFIG_DYNAMIC_DEBUG) && defined(DEBUG)
> 
> Why? All the other call-sites, do it the way Dmitry has done it.

Fine.  Originally I thought it useful to not
store the ratelimit state, but this way those
messages can be enabled via the dynamic_debug
control.

