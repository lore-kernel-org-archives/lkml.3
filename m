Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3FZOTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:19:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51599 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349Ab3FZOTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:19:08 -0400
Message-ID: <1372256348.2076.11.camel@joe-AO722>
Subject: Re: [PATCH] staging: ozwpan: Use normal Makefile, convert oz_trace
 to oz_dbg
From: Joe Perches <joe@perches.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: shigekatsu.tateno@atmel.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Date: Wed, 26 Jun 2013 07:19:08 -0700
In-Reply-To: <1372255013.2076.4.camel@joe-AO722>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
	 <20130625170205.GA21328@kroah.com> <1372181390.1245.68.camel@joe-AO722>
	 <20130625173840.GA8930@kroah.com> <1372208429.1245.94.camel@joe-AO722>
	 <51CAD655.2070208@atmel.com> <1372255013.2076.4.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 06:56 -0700, Joe Perches wrote:
> On Wed, 2013-06-26 at 12:53 +0100, Rupesh Gujare wrote:
> > Above macros look good, however Greg have objection to define new macros 
> > & he had suggested to use dev_dbg() & pr_debug().

These macros already use pr_debug and should
use dev_dbg and netdev_dbg where appropriate
and possible.  These uses also don't depend
on a single saved global "struct device *".

The grouping/verbose flags are just as you
use them now, but a lot simpler and allow
an easy conversion to a runtime module_param.


