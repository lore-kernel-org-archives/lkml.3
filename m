Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3GIA1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:27:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50353 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3GIA1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:27:06 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1373326534.1438.10.camel@x61.thuisdomein>
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com> <20130708192854.GF4927@phenom.dumpdata.com> <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com> <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic> <1373326534.1438.10.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 08 Jul 2013 20:26:15 -0400
To: Paul Bolle <pebolle@tiscali.nl>, Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Matt Wilson <msw@amazon.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, xen-devel@lists.xensource.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mingo@redhat.com,
        tglx@linutronix.de
Message-ID: <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> wrote:
>On Mon, 2013-07-08 at 22:58 +0200, Borislav Petkov wrote:
>> On Mon, Jul 08, 2013 at 01:29:40PM -0700, H. Peter Anvin wrote:
>> > What. The. Fuck.
>> 
>> This is just marvellous: grub2 has a bunch of scripts in /etc/grub.d
>> which rely on the presence of kernel config files in /boot or / and
>> greps them in order to do the menu entries based on the built-in
>> features it finds in them.
>
>0) I've raised this issue a few months ago, but not on the LKML (see
>http://thread.gmane.org/gmane.linux.kernel.virtualization/19126 ).
>
>1) And I also asked whether "userspace [can] require the build system
>to
>keep using some Kconfig symbol" (see
>http://article.gmane.org/gmane.linux.kernel.virtualization/19129 ).
>Peter and you clearly think userspace can't.
>
>2) But anyhow, unless that grub2 configuration file has changed, this
>Kconfig symbol can still be dropped, because grub2's check for it is
>actually superfluous.
>
>
>Paul Bolle

Not so fast please. Linus absolutely abhors breaking user space and I am not comfortable with that idea either. I am not sure if that falls in that category but I am sure we can rope him after rc0 madness has stopped. 

Could you explain to me please why the check in the scripts is superfluous?

Especially as the grand plan is to get rid of CONFIG_XEN_DOM0 and more or less have a backend and fronted config option (since that makes more sense nowadays). And that would make the XEN_DOM0 be obsolete and the XEN_PRIV would be the one that turns a lot of the options needed to compile a kernel that can provide backend driver support. (I am hand waving here). 

I recall (and thank you for pointing to the link) that this raised some questions that never got answered such as are there tools that check /proc/config.gz for example for features? Otherwise should that be eliminated as well? 

-- 
Sent from my Android phone. Please excuse my brevity.
