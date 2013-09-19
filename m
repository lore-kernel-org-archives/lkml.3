Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3ISWxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:53:19 -0400
Received: from nm4-vm3.access.bullet.mail.bf1.yahoo.com ([216.109.114.114]:39694
	"EHLO nm4-vm3.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab3ISWxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:53:18 -0400
X-Yahoo-Newman-Id: 913212.29684.bm@smtp114.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9xzK_Q0VM1kQVHO.60hh09x735gwGyxTIqWhXStyWxpnonB
 TxqG1yq9O5ydum7whUGse5KjJLz7x6BakWtnU7cN9FB_mIgDtCzJEELH88FP
 s.mlqQKHOID8Hd00_YdlBzbPgDYBSzGFiJpoYmIPfei5Z_7Mn2GWrY1Q_7At
 55Kt3sXy2tc21a5byMyV_VRg8v908mcKrBYlNV3VbACuN5gyxo1L4.p_Xde8
 5JeGNCTTnKFtiXzMFxzbuYXASPur..Xg5ty5KpX1l3_nOyjkTrUGnoTyfWYZ
 J._tlfdNdKUgsJX4vpA8zWCkYX3hH68dExpBi7nsfBM0OkafAzFD57j4jt._
 zu1An2aSahgWUI4dDTuBl1JxY0kKn3OPcbD9TuDyQHpPhX_Qbviv_Lzqsyr6
 .AS6DRJGoZWkPBZ3RpQqz2DfEcCyOMp0IsY9kvUbV4tJqJ5aFzu7GoBUeG7L
 lce6Ixp3OXaQDT.kWd_YCbQJoIFVFQQEPIsGu5zbtuTdt5qc3H.QYqeZwzKc
 7sC0AzqrcVwR8KiXDTLW0uBhxRi4VYXy5JIz._KwxZmstND9ziP0iipdSRYw
 oxC2tJk_uUWLsFz572eHhQbn6jIm8AMx86gWJTYpoPKV_k_hTDdRsUXcVsux
 N6LYQQA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp114.sbc.mail.bf1.yahoo.com with SMTP; 19 Sep 2013 15:53:16 -0700 PDT
Message-ID: <523B8078.1070401@att.net>
Date: Thu, 19 Sep 2013 17:53:44 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Santos <daniel.santos@pobox.com>
CC: David Howells <dhowells@redhat.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 1/5] scripts: Add mkstrerror.sh
References: <1379459317-13046-2-git-send-email-daniel.santos@pobox.com> <1379459317-13046-1-git-send-email-daniel.santos@pobox.com> <29168.1379504300@warthog.procyon.org.uk> <523B7C38.8050609@att.net>
In-Reply-To: <523B7C38.8050609@att.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/19/2013 05:35 PM, Daniel Santos wrote:
>
> Hmm, I cannot reproduce the error. :( I'm using next-20130919 
> currently (x86_64), and if I try to just "make O=lib" it fails w/o my 
> patches.  The only file that should depend upon error_strings.h is 
> lib/string.c.

Ahh! I've never seen the "make O=foo" before and just presumed it was an 
alternate directive to specify a directory of the source tree to build.  
I'm certainly glad to learn that the kernel supports out of tree builds! :)

So I am getting the error now and this is because the script expects to 
run in the root of the source tree. This will be an easy fix and I think 
I've figured out the correct place to put the make target for it as well.

Daniel
