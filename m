Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3IWURD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:17:03 -0400
Received: from nm7-vm1.access.bullet.mail.bf1.yahoo.com ([216.109.114.160]:30241
	"EHLO nm7-vm1.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab3IWURC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:17:02 -0400
X-Yahoo-Newman-Id: 373744.46059.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vDF6XS0VM1nr00MjMprDhHJY3aYy2c0ZzQaxaKPpDwEuqqz
 WWGnGZKeQGFGtzaFbuTUxdnJtOJ3vGUQrfn.nUaMlr1zbiFeRQs1TC_HKJLj
 sFswtXdG2I8KEodvsLLoJsfUgQq_dxTLrYIYiJp5utlOqy0b2wS9WPZ5SVMs
 eWeFBd3ObDkGaa.eLlul4yuVbbAPs5kJnW40YNN.8N0B3HIbMa8xBOf4XILg
 czV_p67YFfKNSaeWHO1yBBoL3JYhiQwFbM3JbGouEgLPtL1.D3s0_sXXyVYH
 MQ09ZK6lshTDBJy1o3J12WXfmHvdtjhiX.nO6aZEiPUOGIT1elwoMDwMvJEo
 iBwKuz2JQ3_8DPgkOYh9ipZpqtS5Mw4ImPEr4rrIgSbZyhhHfs33mItZKqs_
 1FK4geEl1fjhf5hNQswVrU6SM_1G2nlbiq6cCB3trkd72.i9uSdkZzIZj3iW
 8xB_XPOZ3jmYHdA9yBSVb_H33quSODzmbLyNUXmrQ6nnAW.u.2rUG4A1V0ov
 y201hKmXVphOivRwcrQHRira3GiG9UxH6XasxeeGAaQsJKUw9s_OqF41DkkK
 Ff.dvSQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp115.sbc.mail.bf1.yahoo.com with SMTP; 23 Sep 2013 13:17:00 -0700 PDT
Message-ID: <5240A1DB.6020906@att.net>
Date: Mon, 23 Sep 2013 15:17:31 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Joe Perches <joe@perches.com>, Daniel Santos <daniel.santos@pobox.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 5/5] lib: Add error string support to printks
References: <1379677551.2021.25.camel@joe-AO722> <1379482610.1787.7.camel@joe-AO722> <1379459317-13046-1-git-send-email-daniel.santos@pobox.com> <1379459317-13046-6-git-send-email-daniel.santos@pobox.com> <22238.1379502295@warthog.procyon.org.uk> <523A5316.50405@att.net> <1379639226.5862.9.camel@joe-AO722> <523BDB55.2000008@att.net> <23301.1379682458@warthog.procyon.org.uk>
In-Reply-To: <23301.1379682458@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 08:07 AM, David Howells wrote:
> I suspect he doesn't really need to implement a "strerror()" function but
> should rather build it straight into printk()/vsprintf().
>
> David

Indeed we don't necessarily *need* a strerror() function per-se, but it 
is an addition to the libc support in the kernel.  I'll leave it up to 
the community to decide rather or not it should be separate or 
integrated into vsprintf.c.  Also, there is no POSIX or GNU libc 
extension (that I am aware of) to print an error name -- a real shame 
imho, so the name strerror_name() is pretty much artificial. Is there a 
significant overhead in having these functions exported?

Personally, I would think that the only reason to have interest in an 
error name or message in the kernel is to output via printk, but I like 
to allow room for the conditions that I may not have thought of.

Daniel
