Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab3CIQw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 11:52:26 -0500
Received: from mail.wdtv.com ([66.118.69.84]:42776 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab3CIQwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 11:52:24 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
Date: Sat, 9 Mar 2013 11:52:21 -0500
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com> <20130309011809.GA4028@lizard.sbx05280.losalca.wayport.net> <CAP=VYLpxZzi6OFpDjJaR2EVcgmS4EcoAAk5wSzjrbi+QSfaEWw@mail.gmail.com>
In-Reply-To: <CAP=VYLpxZzi6OFpDjJaR2EVcgmS4EcoAAk5wSzjrbi+QSfaEWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201303091152.21854.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 March 2013, Paul Gortmaker wrote:

I'd Cc: Paul's whole list, but it would bounce, so I'll post this where it 
will be seen.

>On Fri, Mar 8, 2013 at 8:18 PM, Anton Vorontsov <anton@enomsg.org> wrote:
>> Hi Paul,
>> 
>> On Fri, Mar 08, 2013 at 11:38:41AM -0500, Paul Gortmaker wrote:
>>> > I see. In that case, please feel free to send the patch to akpm with
>>> > my Nack and pointing to this discussion. If Andrew agrees and I was
>>> > wrong (and I'm really curious whether I am right or wrong), I will
>>> > start applying such patches in future.
>>> 
>>> I didn't send the patch to akpm, but I did have a chance to ask akpm
>>> how
>>> 
>>> dependencies should be used, and you can see his answer here:
>>>       https://lkml.org/lkml/2013/3/7/456
>> 
>> Thanks for asking! FWIW, I won't be against CONFIG_AKPM. ;-) Something
>> 
>> like that will work:
>>         depends on GENERIC_HARDIRQS
>>         depends on RESTRICT_PLATFORM && GOLDFISH
>> 
>> But not that I think we really need this option, though. Whoever wants
>> to
>
>Of course, it was only meant sarcastically, but the CONFIG_AKPM
>joke wasn't the important part of the email discussion though.
>
>Above,  you asked "If Andrew agrees [that dependencies should describe
>the hardware/platform] ... I will start applying such patches in future."
>
>The important bit is Andrew's answer to your question:
>
>  "...offering useless stuff to non-kernel-developers has downsides
>  with no balancing benefit, and we really should optimise things
>  for our users because there are so many more of them than there
>  are of us."
>
>That seems quite clear that we should be using dependencies to
>properly describe the real system layout, and not offer up
>useless stuff.  It is unclear to me how anyone could  interpret
>it any different way -- i.e. GOLDFISH_POWER should depend on
>GOLDFISH, just like the other GOLDFISH_XYZ options do now.
>
>> (re)build the kernel is assumed to be knowledgeable enough to figure
>> out what needed/unneeded for the given HW. I, for example, use
>> 'ARCH=foo
>
>This is another problem though -- as mentioned at kernel summit,
>more people testing newer kernels is desired, but the barrier to entry
>seems too high, and one of those barriers is Kconfig complexity.
>Assuming everybody is "knowledgeable enough" does not match
>reality.
>
>Paul.

I'll have to agree about the high barrier but you are placing the blame on 
Kconfig, whereas I place that blame squarely on 2 other points, first being 
the compiler speed, the 2nd, all the virtually undocumented changes to grub 
since about 2007.

When I built this 2.1 Ghz quad core 9550 phenom box with 4Gb of dram, I 
could build the then current kernel, using my own install script, the 
compiler version of that day, edit /boot/grub/grub.cfg and be rebooted to 
it in 20 minutes.

Same machine, fast fwd to 2 years ago, the start of my script to end of 
make modules phase was over 2 hours, and of course the install failed 
because the grub.cfg that counts no longer lives in /boot/grub, but is now 
buried in a directory in /etc.

Sure, I can fix my script to deal with the new grub I'd expect, but grubs 
new docs contain a 10-33 tor vacuum in terms of what this or that option 
really does, and what file to put that option in so its quasi-permanent for 
this kernel.  And taking 2, now probably over 3 hours to build the kernel 
of the week is patently excessive.  Your current compiler may be generating 
more precise code for my cpu, but its spinning its wheels at 2.1Ghz to get 
.5 kilohertz effective speed on my quad core phenom.  Seriously folks, WTH?

So I'm still here, lurking, but you have lost a tester when it takes 2 or 3 
hours to find out if it will even boot on a machine that was considered a 
server grade machine when it was new.  

I might add that it might have gotten 55 megs into swap in 2 weeks uptime 
then, now its 6days uptime and 326 megs into swap, needing a reboot as a 
swapoff -a;swapon -a will kill something important.  Like dbus for 
instance.

One former testers 2 cents.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
My views 
<http://www.armchairpatriot.com/What%20Has%20America%20Become.shtml>
People don't usually make the same mistake twice -- they make it three
times, four time, five times...
I was taught to respect my elders, but its getting 
harder and harder to find any...
