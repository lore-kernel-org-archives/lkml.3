Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3HFNTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:19:05 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:52456 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3HFNTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:19:03 -0400
Message-ID: <5200F7C2.8090802@monstr.eu>
Date: Tue, 06 Aug 2013 15:18:58 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbWFu?= =?UTF-8?B?bg==?= 
	<soren.brinkmann@xilinx.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <51F77D93.4030505@linaro.org> <51F97842.6050200@linaro.org> <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local> <51F97CE3.9030306@linaro.org> <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local> <51F99747.4060901@linaro.org> <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local> <51FA9AE8.1060004@linaro.org> <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local> <51FA9F54.3060704@linaro.org> <712d31e9-3584-48e1-aa9f-55bc94fa62c9@DB9EHSMHS001.ehs.local> <5200B7FE.4000306@linaro.org> <e43ebbd7-f520-4c66-bc8c-71a1122226ad@CO9EHSMHS020.ehs.local> <5200EC4C.5090202@linaro.org> <07cc684f-1d5c-44d7-b25c-6314efea4c58@CO9EHSMHS022.ehs.local> <5200F553.6000200@linaro.org>
In-Reply-To: <5200F553.6000200@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SMukdjws6k70XUguQxUUHjJeu1tbrlu43"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SMukdjws6k70XUguQxUUHjJeu1tbrlu43
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/06/2013 03:08 PM, Daniel Lezcano wrote:
> On 08/06/2013 02:41 PM, Michal Simek wrote:
>> On 08/06/2013 02:30 PM, Daniel Lezcano wrote:
>>> On 08/06/2013 11:18 AM, Michal Simek wrote:
>>>> On 08/06/2013 10:46 AM, Daniel Lezcano wrote:
>>>>> On 08/06/2013 03:28 AM, S=C3=B6ren Brinkmann wrote:
>>>>>> Hi Daniel,
>>>>>>
>>>>>> On Thu, Aug 01, 2013 at 07:48:04PM +0200, Daniel Lezcano wrote:
>>>>>>> On 08/01/2013 07:43 PM, S=C3=B6ren Brinkmann wrote:
>>>>>>>> On Thu, Aug 01, 2013 at 07:29:12PM +0200, Daniel Lezcano wrote:
>>>>>>>>> On 08/01/2013 01:38 AM, S=C3=B6ren Brinkmann wrote:
>>>>>>>>>> On Thu, Aug 01, 2013 at 01:01:27AM +0200, Daniel Lezcano wrote=
:
>>>>>>>>>>> On 08/01/2013 12:18 AM, S=C3=B6ren Brinkmann wrote:
>>>>>>>>>>>> On Wed, Jul 31, 2013 at 11:08:51PM +0200, Daniel Lezcano wro=
te:
>>>>>>>>>>>>> On 07/31/2013 10:58 PM, S=C3=B6ren Brinkmann wrote:
>>>>>>>>>>>>>> On Wed, Jul 31, 2013 at 10:49:06PM +0200, Daniel Lezcano w=
rote:
>>>>>>>>>>>>>>> On 07/31/2013 12:34 AM, S=C3=B6ren Brinkmann wrote:
>>>>>>>>>>>>>>>> On Tue, Jul 30, 2013 at 10:47:15AM +0200, Daniel Lezcano=
 wrote:
>>>>>>>>>>>>>>>>> On 07/30/2013 02:03 AM, S=C3=B6ren Brinkmann wrote:
>>>>>>>>>>>>>>>>>> Hi Daniel,
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> On Mon, Jul 29, 2013 at 02:51:49PM +0200, Daniel Lezca=
no wrote:
>>>>>>>>>>>>>>>>>> (snip)
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> the CPUIDLE_FLAG_TIMER_STOP flag tells the cpuidle fr=
amework the local
>>>>>>>>>>>>>>>>>>> timer will be stopped when entering to the idle state=
=2E In this case, the
>>>>>>>>>>>>>>>>>>> cpuidle framework will call clockevents_notify(ENTER)=
 and switches to a
>>>>>>>>>>>>>>>>>>> broadcast timer and will call clockevents_notify(EXIT=
) when exiting the
>>>>>>>>>>>>>>>>>>> idle state, switching the local timer back in use.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> I've been thinking about this, trying to understand ho=
w this makes my
>>>>>>>>>>>>>>>>>> boot attempts on Zynq hang. IIUC, the wrongly provided=
 TIMER_STOP flag
>>>>>>>>>>>>>>>>>> would make the timer core switch to a broadcast device=
 even though it
>>>>>>>>>>>>>>>>>> wouldn't be necessary. But shouldn't it still work? It=
 sounds like we do
>>>>>>>>>>>>>>>>>> something useless, but nothing wrong in a sense that i=
t should result in
>>>>>>>>>>>>>>>>>> breakage. I guess I'm missing something obvious. This =
timer system will
>>>>>>>>>>>>>>>>>> always remain a mystery to me.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Actually this more or less leads to the question: What=
 is this
>>>>>>>>>>>>>>>>>> 'broadcast timer'. I guess that is some clockevent dev=
ice which is
>>>>>>>>>>>>>>>>>> common to all cores? (that would be the cadence_ttc fo=
r Zynq). Is the
>>>>>>>>>>>>>>>>>> hang pointing to some issue with that driver?
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> If you look at the /proc/timer_list, which timer is use=
d for broadcasting ?
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> So, the correct run results (full output attached).
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The vanilla kernel uses the twd timers as local timers a=
nd the TTC as
>>>>>>>>>>>>>>>> broadcast device:
>>>>>>>>>>>>>>>> 	Tick Device: mode:     1                               =
                         =20
>>>>>>>>>>>>>>>> 	Broadcast device =20
>>>>>>>>>>>>>>>> 	Clock Event Device: ttc_clockevent
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> When I remove the offending CPUIDLE flag and add the DT =
fragment to
>>>>>>>>>>>>>>>> enable the global timer, the twd timers are still used a=
s local timers
>>>>>>>>>>>>>>>> and the broadcast device is the global timer:
>>>>>>>>>>>>>>>> 	Tick Device: mode:     1                               =
                         =20
>>>>>>>>>>>>>>>> 	Broadcast device                                       =
                         =20
>>>>>>>>>>>>>>>> 	Clock Event Device: arm_global_timer
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Again, since boot hangs in the actually broken case, I d=
on't see way to
>>>>>>>>>>>>>>>> obtain this information for that case.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Can't you use the maxcpus=3D1 option to ensure the system=
 to boot up ?
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Right, that works. I forgot about that option after you me=
ntioned, that
>>>>>>>>>>>>>> it is most likely not that useful.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Anyway, this are those sysfs files with an unmodified cpui=
dle driver and
>>>>>>>>>>>>>> the gt enabled and having maxcpus=3D1 set.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> /proc/timer_list:
>>>>>>>>>>>>>> 	Tick Device: mode:     1
>>>>>>>>>>>>>> 	Broadcast device
>>>>>>>>>>>>>> 	Clock Event Device: arm_global_timer
>>>>>>>>>>>>>> 	 max_delta_ns:   12884902005
>>>>>>>>>>>>>> 	 min_delta_ns:   1000
>>>>>>>>>>>>>> 	 mult:           715827876
>>>>>>>>>>>>>> 	 shift:          31
>>>>>>>>>>>>>> 	 mode:           3
>>>>>>>>>>>>>
>>>>>>>>>>>>> Here the mode is 3 (CLOCK_EVT_MODE_ONESHOT)
>>>>>>>>>>>>>
>>>>>>>>>>>>> The previous timer_list output you gave me when removing th=
e offending
>>>>>>>>>>>>> cpuidle flag, it was 1 (CLOCK_EVT_MODE_SHUTDOWN).
>>>>>>>>>>>>>
>>>>>>>>>>>>> Is it possible you try to get this output again right after=
 onlining the
>>>>>>>>>>>>> cpu1 in order to check if the broadcast device switches to =
SHUTDOWN ?
>>>>>>>>>>>>
>>>>>>>>>>>> How do I do that? I tried to online CPU1 after booting with =
maxcpus=3D1
>>>>>>>>>>>> and that didn't end well:
>>>>>>>>>>>> 	# echo 1 > online && cat /proc/timer_list=20
>>>>>>>>>>>
>>>>>>>>>>> Hmm, I was hoping to have a small delay before the kernel han=
gs but
>>>>>>>>>>> apparently this is not the case... :(
>>>>>>>>>>>
>>>>>>>>>>> I suspect the global timer is shutdown at one moment but I do=
n't
>>>>>>>>>>> understand why and when.
>>>>>>>>>>>
>>>>>>>>>>> Can you add a stack trace in the "clockevents_shutdown" funct=
ion with
>>>>>>>>>>> the clockevent device name ? Perhaps, we may see at boot time=
 an
>>>>>>>>>>> interesting trace when it hangs.
>>>>>>>>>>
>>>>>>>>>> I did this change:
>>>>>>>>>> 	diff --git a/kernel/time/clockevents.c b/kernel/time/clockeve=
nts.c
>>>>>>>>>> 	index 38959c8..3ab11c1 100644
>>>>>>>>>> 	--- a/kernel/time/clockevents.c
>>>>>>>>>> 	+++ b/kernel/time/clockevents.c
>>>>>>>>>> 	@@ -92,6 +92,8 @@ void clockevents_set_mode(struct clock_even=
t_device *dev,
>>>>>>>>>> 	  */
>>>>>>>>>> 	 void clockevents_shutdown(struct clock_event_device *dev)
>>>>>>>>>> 	 {
>>>>>>>>>> 	+       pr_info("ce->name:%s\n", dev->name);
>>>>>>>>>> 	+       dump_stack();
>>>>>>>>>> 	        clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
>>>>>>>>>> 	        dev->next_event.tv64 =3D KTIME_MAX;
>>>>>>>>>> 	 }
>>>>>>>>>>
>>>>>>>>>> It is hit a few times during boot, so I attach a full boot log=
=2E I really
>>>>>>>>>> don't know what to look for, but I hope you can spot something=
 in it. I
>>>>>>>>>> really appreciate you taking the time.
>>>>>>>>>
>>>>>>>>> Thanks for the traces.
>>>>>>>>
>>>>>>>> Sure.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> If you try without the ttc_clockevent configured in the kernel =
(but with
>>>>>>>>> twd and gt), does it boot ?
>>>>>>>>
>>>>>>>> Absence of the TTC doesn't seem to make any difference. It hangs=
 at the
>>>>>>>> same location.
>>>>>>>
>>>>>>> Ok, IMO there is a problem with the broadcast device registration=
 (may
>>>>>>> be vs twd).
>>>>>>>
>>>>>>> I will check later (kid duty) :)
>>>>>>
>>>>>> I was actually waiting for an update from your side and did someth=
ing
>>>>>> else, but I seem to have run into this again. I was overhauling th=
e
>>>>>> cadence_ttc (patch attached, based on tip/timers/core). And it see=
ms to
>>>>>> show the same behavior as enabling the global_timer. With cpuidle =
off, it
>>>>>> works. With cpuidle, on it hangs. Removing the TIMER_STOP flag fro=
m the
>>>>>> C2 state makes it boot again.
>>>>>> It works just fine on our 3.10 kernel.
>>>>>
>>>>> This is not necessary related to the bug. If the patch you sent bro=
ke
>>>>> the cadence_ttc driver, when you use it (with the TIMER_STOP), you =
will
>>>>> be stuck. Removing the flag, may signifies you don't use the broadc=
ast
>>>>> timer, hence the bug is not surfacing.
>>>>>
>>>>> Going back to the bug with the arm_global_timer, what is observed i=
s the
>>>>> broadcast timer is *shutdown* when the second cpu is online.
>>>>>
>>>>> I have to dig into the kernel/time/clockevents.c|tick-*.c because I=
MO
>>>>> the issue is coming from there but before I have to reproduce the b=
ug,
>>>>> so find a board I have where I can add the arm_global_timer.
>>>>>
>>>>>> Another thing I noticed - probably unrelated but hard to tell: On
>>>>>> 3.11-rc1 and later my system stops for quite some time at the hand=
 off
>>>>>> to userspace. I.e. I see the 'freeing unused kernel memory...' lin=
e and
>>>>>> sometimes the following 'Welcome to Buildroot...' and then it stop=
s and
>>>>>> on good kernels it continues after a while and boots through and o=
n bad
>>>>>> ones it just hangs there.
>>>>>
>>>>> did you try to dump the stacks with magic-sysrq ? Or git bisect ?
>>>>
>>>> Soren: Are you able to replicate this issue on QEMU?
>>>> If yes, it should be the best if you can provide Qemu, kernel .confi=
g/
>>>> rootfs and simple manual to Daniel how to reach that fault.
>>>
>>> I tried to download qemu for zynq but it fails:
>>>
>>> git clone git://git.xilinx.com/qemu-xarm.git
>>> Cloning into 'qemu-xarm'...
>>> fatal: The remote end hung up unexpectedly
>>
>> Not sure which site have you found but
>> it should be just qemu.git
>> https://github.com/Xilinx/qemu
>>
>> or github clone.
>=20
> Ok, cool I was able to clone it.
>=20
>>> I am also looking for the option specified for the kernel:
>>>
>>> "The kernel needs to be built with this feature turned on (in
>>> menuconfig, System Type->Xilinx Specific Features -> Device Tree At
>>> Fixed Address)."
>=20
> Ok.
>=20
>> This also sound like a very ancient tree.
>> This is the latest kernel tree - master-next is the latest devel branc=
h.
>> https://github.com/Xilinx/linux-xlnx
>=20
> Ok, cool. I have the right one.
>=20
>> Or there should be an option to use the latest kernel from kernel.org.=

>> (I think Soren is using it)
>>
>> Zynq is the part of multiplatfrom kernel and cadence ttc is there,
>> dts is also in the mainline kernel.
>>
>>> ps : apart that, well documented website !
>>
>> Can you send me the link to it?
>=20
> http://xilinx.wikidot.com/zynq-qemu
> http://xilinx.wikidot.com/zynq-linux

I will find out information why it is still there.
I think it was moved to the new location.

>=20
>> This should be the main page for it.
>> http://www.wiki.xilinx.com/
>=20
> Thanks Michal !

Thank you too Daniel,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--SMukdjws6k70XUguQxUUHjJeu1tbrlu43
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIA98IACgkQykllyylKDCGUvwCfXhYve/BJJjtn996i1Qr/Ve38
TLEAn1tVF7xgzapzCkxkw0ae8yBsafLg
=7TJx
-----END PGP SIGNATURE-----

--SMukdjws6k70XUguQxUUHjJeu1tbrlu43--
