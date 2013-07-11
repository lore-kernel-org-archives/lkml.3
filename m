Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3GKSOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 14:14:01 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:60187 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab3GKSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:14:00 -0400
Message-ID: <1373566438.1349.21.camel@x61.thuisdomein>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
From: Paul Bolle <pebolle@tiscali.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Matt Wilson <msw@amazon.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, xen-devel@lists.xensource.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mingo@redhat.com,
        tglx@linutronix.de
Date: Thu, 11 Jul 2013 20:13:58 +0200
In-Reply-To: <51DEF1F3.2020900@zytor.com>
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
	  <20130708192854.GF4927@phenom.dumpdata.com>
	  <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
	  <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic>
	  <1373326534.1438.10.camel@x61.thuisdomein>
	  <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
	 <1373537338.9708.18.camel@x61.thuisdomein> <51DEF1F3.2020900@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2013 18:13:58.0553 (UTC) FILETIME=[69B29890:01CE7E62]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 10:57 -0700, H. Peter Anvin wrote:
> On 07/11/2013 03:08 AM, Paul Bolle wrote:
> > But the Kconfig entry for XEN_PRIVILEGED_GUEST reads: 
> >     # Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
> >     # name in tools.
> >     config XEN_PRIVILEGED_GUEST
> >             def_bool XEN_DOM0
> > 
> > In other words: CONFIG_XEN_PRIVILEGED_GUEST should always be equal to
> > CONFIG_XEN_DOM0. So the two grep commands should always both evaluate to
> > true or both evaluate to false. One of these two commands can safely be
> > dropped.
> 
> Not necessarily true across kernel versions.

Correct. But it has actually been true ever since this Kconfig entry was
introduced in v2.6.37 (commit 6b0661a5e6fbfb159b78a39c0476905aa9b575fe,
"xen: introduce XEN_DOM0 as a silent option").

So people need not worry about breaking grub2 by dropping
XEN_PRIVILEGED_GUEST.


Paul Bolle

