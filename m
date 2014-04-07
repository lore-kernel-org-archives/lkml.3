Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaDGACV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 20:02:21 -0400
Received: from mail.wdtv.com ([66.118.69.84]:44261 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbaDGACS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 20:02:18 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig circular dependency question
Date: Sun, 6 Apr 2014 20:02:12 -0400
References: <5341AFC7.1070001@lwfinger.net> <5341B999.3050206@infradead.org> <1396817575.4886.23.camel@x220>
In-Reply-To: <1396817575.4886.23.camel@x220>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201404062002.12286.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 April 2014, Paul Bolle wrote:
>On Sun, 2014-04-06 at 13:31 -0700, Randy Dunlap wrote:
>> and/or changing MOUSE_APPLETOUCH to depend on USB instead of select it?
>
>MOUSE_APPLETOUCH selects USB and depends on USB_ARCH_HAS_HCD. That's
>actually quite a common pattern.
>
>But what is the purpose of USB_ARCH_HAS_HCD? It is set by default if
>USB_SUPPORT is set. And USB depends on it, but since USB also depends on
>USB_SUPPORT that seems superfluous.
>
>My slow day continues, because I find this hard to grok.
>
>
>Paul Bolle

Rant mode on.

I don't find it at all hard to use my toothpick sized oar here to bitch 
about de-selected subsystems that are buried so far in dependencies that 
you simply cannot find the options you need in a make xconfig or make 
menuconfig.

To have a whole genre of drivers simply disappear, never to be seen again 
by someone trying to configure a working kernel, just because some 
upstream, totally unrelated upstream dependency isn't checked, is nothing 
short of asinine.

I just spent a month building a new kernel here, and finally had to resort 
to editing the individual trees kconfig files to get a 3.13.6 PAE kernel to 
build, and it STILL won't play videos without extremely distracting audio  
stutters and many second long video freezes, followed by 300 frames a 
second catchups.

Reboot to Ubu1204.3 LTS, works perfectly, except kmail crashes even before 
opening its screen, with an error no one on the kubuntu lists has ever 
seen.  I can't work without a working email agent.

I had to search thru the far ends of the driver trees, looking at kconfig 
files to see what parent dependencies they might contain, cd back up the 
tree one level and make sure that kconfig had its dependencies met, clear 
back up to the root kconfig.  This went on, building and rebooting to at 
least 3 kernels an evening for damned near a month to even get where I am 
ATM.  Thats not excusable.  Do not ever hide shit, make it ALL visible, and 
if I check a driver my hardware needs, it should cascade back up thru the 
tree calling in every other thing that driver needs, whether its selected 
in the parent kconfigs or not.  If that attitude steps on somebodies toes, 
I don't have a quarter to call anybody who cares.

This from someone who has been a linux only house since RH5.0, in what, 
1997 or 1998?

You have, in the last few years, been painting yourself into a corner with 
the *config's.  FIX IT.

/Rant mode off.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

