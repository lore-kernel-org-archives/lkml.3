Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965931Ab3HHRXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:23:05 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:46174
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757910Ab3HHRXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:23:01 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371Ic89bh146fI1432Ic857h1447Ide40hzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2fh95h668h839hd24hf0ah119dh1288h12a5h12bdh137ah1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1bceh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h906i34h1155h192ch)
Date: Thu, 8 Aug 2013 10:22:46 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local>
 <51F97CE3.9030306@linaro.org>
 <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local>
 <51F99747.4060901@linaro.org>
 <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local>
 <51FA9AE8.1060004@linaro.org>
 <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
 <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local>
 <20130808171650.GH27325@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20130808171650.GH27325@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2ce85f6c-36a8-4fb8-8e70-693e87de4e18@VA3EHSMHS028.ehs.local>
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2013 at 06:16:50PM +0100, Mark Rutland wrote:
> On Thu, Aug 08, 2013 at 06:11:26PM +0100, S=C3=B6ren Brinkmann wrote:
> > Hi Daniel,
> > =

> > On Thu, Aug 01, 2013 at 07:48:04PM +0200, Daniel Lezcano wrote:
> > > On 08/01/2013 07:43 PM, S=C3=B6ren Brinkmann wrote:
> > > > On Thu, Aug 01, 2013 at 07:29:12PM +0200, Daniel Lezcano wrote:
> > > >> On 08/01/2013 01:38 AM, S=C3=B6ren Brinkmann wrote:
> > > >>> On Thu, Aug 01, 2013 at 01:01:27AM +0200, Daniel Lezcano wrote:
> > > >>>> On 08/01/2013 12:18 AM, S=C3=B6ren Brinkmann wrote:
> > > >>>>> On Wed, Jul 31, 2013 at 11:08:51PM +0200, Daniel Lezcano wrote:=

> > > >>>>>> On 07/31/2013 10:58 PM, S=C3=B6ren Brinkmann wrote:
> > > >>>>>>> On Wed, Jul 31, 2013 at 10:49:06PM +0200, Daniel Lezcano wrot=
e:
> > > >>>>>>>> On 07/31/2013 12:34 AM, S=C3=B6ren Brinkmann wrote:
> > > >>>>>>>>> On Tue, Jul 30, 2013 at 10:47:15AM +0200, Daniel Lezcano wr=
ote:
> > > >>>>>>>>>> On 07/30/2013 02:03 AM, S=C3=B6ren Brinkmann wrote:
> > > >>>>>>>>>>> Hi Daniel,
> > > >>>>>>>>>>>
> > > >>>>>>>>>>> On Mon, Jul 29, 2013 at 02:51:49PM +0200, Daniel Lezcano =
wrote:
> > > >>>>>>>>>>> (snip)
> > > >>>>>>>>>>>>
> > > >>>>>>>>>>>> the CPUIDLE_FLAG_TIMER_STOP flag tells the cpuidle frame=
work the local
> > > >>>>>>>>>>>> timer will be stopped when entering to the idle state. I=
n this case, the
> > > >>>>>>>>>>>> cpuidle framework will call clockevents_notify(ENTER) an=
d switches to a
> > > >>>>>>>>>>>> broadcast timer and will call clockevents_notify(EXIT) w=
hen exiting the
> > > >>>>>>>>>>>> idle state, switching the local timer back in use.
> > > >>>>>>>>>>>
> > > >>>>>>>>>>> I've been thinking about this, trying to understand how t=
his makes my
> > > >>>>>>>>>>> boot attempts on Zynq hang. IIUC, the wrongly provided TI=
MER_STOP flag
> > > >>>>>>>>>>> would make the timer core switch to a broadcast device ev=
en though it
> > > >>>>>>>>>>> wouldn't be necessary. But shouldn't it still work? It so=
unds like we do
> > > >>>>>>>>>>> something useless, but nothing wrong in a sense that it s=
hould result in
> > > >>>>>>>>>>> breakage. I guess I'm missing something obvious. This tim=
er system will
> > > >>>>>>>>>>> always remain a mystery to me.
> > > >>>>>>>>>>>
> > > >>>>>>>>>>> Actually this more or less leads to the question: What is=
 this
> > > >>>>>>>>>>> 'broadcast timer'. I guess that is some clockevent device=
 which is
> > > >>>>>>>>>>> common to all cores? (that would be the cadence_ttc for Z=
ynq). Is the
> > > >>>>>>>>>>> hang pointing to some issue with that driver?
> > > >>>>>>>>>>
> > > >>>>>>>>>> If you look at the /proc/timer_list, which timer is used f=
or broadcasting ?
> > > >>>>>>>>>
> > > >>>>>>>>> So, the correct run results (full output attached).
> > > >>>>>>>>>
> > > >>>>>>>>> The vanilla kernel uses the twd timers as local timers and =
the TTC as
> > > >>>>>>>>> broadcast device:
> > > >>>>>>>>>     Tick Device: mode:     1
> > > >>>>>>>>>     Broadcast device
> > > >>>>>>>>>     Clock Event Device: ttc_clockevent
> > > >>>>>>>>>
> > > >>>>>>>>> When I remove the offending CPUIDLE flag and add the DT fra=
gment to
> > > >>>>>>>>> enable the global timer, the twd timers are still used as l=
ocal timers
> > > >>>>>>>>> and the broadcast device is the global timer:
> > > >>>>>>>>>     Tick Device: mode:     1
> > > >>>>>>>>>     Broadcast device
> > > >>>>>>>>>     Clock Event Device: arm_global_timer
> > > >>>>>>>>>
> > > >>>>>>>>> Again, since boot hangs in the actually broken case, I don'=
t see way to
> > > >>>>>>>>> obtain this information for that case.
> > > >>>>>>>>
> > > >>>>>>>> Can't you use the maxcpus=3D1 option to ensure the system to=
 boot up ?
> > > >>>>>>>
> > > >>>>>>> Right, that works. I forgot about that option after you menti=
oned, that
> > > >>>>>>> it is most likely not that useful.
> > > >>>>>>>
> > > >>>>>>> Anyway, this are those sysfs files with an unmodified cpuidle=
 driver and
> > > >>>>>>> the gt enabled and having maxcpus=3D1 set.
> > > >>>>>>>
> > > >>>>>>> /proc/timer_list:
> > > >>>>>>>       Tick Device: mode:     1
> > > >>>>>>>       Broadcast device
> > > >>>>>>>       Clock Event Device: arm_global_timer
> > > >>>>>>>        max_delta_ns:   12884902005
> > > >>>>>>>        min_delta_ns:   1000
> > > >>>>>>>        mult:           715827876
> > > >>>>>>>        shift:          31
> > > >>>>>>>        mode:           3
> > > >>>>>>
> > > >>>>>> Here the mode is 3 (CLOCK_EVT_MODE_ONESHOT)
> > > >>>>>>
> > > >>>>>> The previous timer_list output you gave me when removing the o=
ffending
> > > >>>>>> cpuidle flag, it was 1 (CLOCK_EVT_MODE_SHUTDOWN).
> > > >>>>>>
> > > >>>>>> Is it possible you try to get this output again right after on=
lining the
> > > >>>>>> cpu1 in order to check if the broadcast device switches to SHU=
TDOWN ?
> > > >>>>>
> > > >>>>> How do I do that? I tried to online CPU1 after booting with max=
cpus=3D1
> > > >>>>> and that didn't end well:
> > > >>>>>         # echo 1 > online && cat /proc/timer_list
> > > >>>>
> > > >>>> Hmm, I was hoping to have a small delay before the kernel hangs =
but
> > > >>>> apparently this is not the case... :(
> > > >>>>
> > > >>>> I suspect the global timer is shutdown at one moment but I don't=

> > > >>>> understand why and when.
> > > >>>>
> > > >>>> Can you add a stack trace in the "clockevents_shutdown" function=
 with
> > > >>>> the clockevent device name ? Perhaps, we may see at boot time an=

> > > >>>> interesting trace when it hangs.
> > > >>>
> > > >>> I did this change:
> > > >>>   diff --git a/kernel/time/clockevents.c b/kernel/time/clockevent=
s.c
> > > >>>   index 38959c8..3ab11c1 100644
> > > >>>   --- a/kernel/time/clockevents.c
> > > >>>   +++ b/kernel/time/clockevents.c
> > > >>>   @@ -92,6 +92,8 @@ void clockevents_set_mode(struct clock_event_=
device *dev,
> > > >>>     */
> > > >>>    void clockevents_shutdown(struct clock_event_device *dev)
> > > >>>    {
> > > >>>   +       pr_info("ce->name:%s\n", dev->name);
> > > >>>   +       dump_stack();
> > > >>>           clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> > > >>>           dev->next_event.tv64 =3D KTIME_MAX;
> > > >>>    }
> > > >>>
> > > >>> It is hit a few times during boot, so I attach a full boot log. I=
 really
> > > >>> don't know what to look for, but I hope you can spot something in=
 it. I
> > > >>> really appreciate you taking the time.
> > > >>
> > > >> Thanks for the traces.
> > > >
> > > > Sure.
> > > >
> > > >>
> > > >> If you try without the ttc_clockevent configured in the kernel (bu=
t with
> > > >> twd and gt), does it boot ?
> > > >
> > > > Absence of the TTC doesn't seem to make any difference. It hangs at=
 the
> > > > same location.
> > >
> > > Ok, IMO there is a problem with the broadcast device registration (ma=
y
> > > be vs twd).
> > =

> > I have an idea, but no real evidence to prove it:
> > Some of the registers in the arm_global_timer are banked per CPU. I.e.
> > some code must be executed on the CPU the timer is associated with
> > (struct clock_event_device.cpumask) to have the intended effect
> > As far as I can tell, there is no guarantee, that the set_mode()
> > and program_next_event() calls execute on the correct CPU.
> =

> I believe the core clockevents code enforces that, or all other percpu
> clockevent_device drivers would be horrifically broken.

Well, I have some evidence. I booted into the system (bootlog attached).
It seems to be luck to not deadlock.
In between I also had some additional print statements in the global
timer driver which seemed to back up my suspicion.

This is the ugly hack I added to the clockevents core:

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 38959c8..419c973 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -59,6 +59,20 @@ u64 clockevent_delta2ns(unsigned long latch, struct cloc=
k_event_device *evt)
 }
 EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 =

+struct ce_set_mode_args {
+	struct clock_event_device *dev;
+	enum clock_event_mode mode;
+};
+
+static struct ce_set_mode_args ce_mode_args;
+
+static void ce_set_mode_xcall(void *info)
+{
+	struct ce_set_mode_args *args =3D info;
+
+	args->dev->set_mode(args->mode, args->dev);
+}
+
 /**
  * clockevents_set_mode - set the operating mode of a clock event device
  * @dev:	device to modify
@@ -70,7 +84,10 @@ void clockevents_set_mode(struct clock_event_device *dev=
,
 				 enum clock_event_mode mode)
 {
 	if (dev->mode !=3D mode) {
-		dev->set_mode(mode, dev);
+		ce_mode_args.mode =3D mode;
+		ce_mode_args.dev =3D dev;
+		smp_call_function_any(dev->cpumask, ce_set_mode_xcall,
+				&ce_mode_args, 1);
 		dev->mode =3D mode;
 =

 		/*
@@ -96,6 +113,20 @@ void clockevents_shutdown(struct clock_event_device *de=
v)
 	dev->next_event.tv64 =3D KTIME_MAX;
 }
 =

+struct ce_prog_eve_args {
+	struct clock_event_device *dev;
+	unsigned long clc;
+};
+
+static struct ce_prog_eve_args ce_prog_eve_args;
+
+static void  ce_prog_event_xcall(void *info)
+{
+	struct ce_prog_eve_args *args =3D info;
+
+	args->dev->set_next_event(args->clc, args->dev);
+}
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST
 =

 /* Limit min_delta to a jiffie */
@@ -141,6 +172,7 @@ static int clockevents_program_min_delta(struct clock_e=
vent_device *dev)
 	unsigned long long clc;
 	int64_t delta;
 	int i;
+	int cpu;
 =

 	for (i =3D 0;;) {
 		delta =3D dev->min_delta_ns;
@@ -151,8 +183,11 @@ static int clockevents_program_min_delta(struct clock_=
event_device *dev)
 =

 		dev->retries++;
 		clc =3D ((unsigned long long) delta * dev->mult) >> dev->shift;
-		if (dev->set_next_event((unsigned long) clc, dev) =3D=3D 0)
-			return 0;
+		ce_prog_eve_args.clc =3D clc;
+		ce_prog_eve_args.dev =3D dev;
+		smp_call_function_any(dev->cpumask, ce_prog_event_xcall,
+				&ce_prog_eve_args, 1);
+		return 0;
 =

 		if (++i > 2) {
 			/*
@@ -179,6 +214,7 @@ static int clockevents_program_min_delta(struct clock_e=
vent_device *dev)
 {
 	unsigned long long clc;
 	int64_t delta;
+	int ret;
 =

 	delta =3D dev->min_delta_ns;
 	dev->next_event =3D ktime_add_ns(ktime_get(), delta);
@@ -188,7 +224,13 @@ static int clockevents_program_min_delta(struct clock_=
event_device *dev)
 =

 	dev->retries++;
 	clc =3D ((unsigned long long) delta * dev->mult) >> dev->shift;
-	return dev->set_next_event((unsigned long) clc, dev);
+	ce_prog_eve_args.clc =3D clc;
+	ce_prog_eve_args.dev =3D dev;
+	smp_call_function_any(dev->cpumask, ce_prog_event_xcall,
+			&ce_prog_eve_args, 1);
+	ret =3D 0;
+
+	return ret;
 }
 =

 #endif /* CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST */
@@ -230,7 +272,11 @@ int clockevents_program_event(struct clock_event_devic=
e *dev, ktime_t expires,
 	delta =3D max(delta, (int64_t) dev->min_delta_ns);
 =

 	clc =3D ((unsigned long long) delta * dev->mult) >> dev->shift;
-	rc =3D dev->set_next_event((unsigned long) clc, dev);
+	ce_prog_eve_args.clc =3D clc;
+	ce_prog_eve_args.dev =3D dev;
+	smp_call_function_any(dev->cpumask, ce_prog_event_xcall,
+			&ce_prog_eve_args, 1);
+	rc =3D 0;
 =

 	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
 }


 	S=C3=B6ren


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset="utf-8"
Content-Disposition: attachment; filename="boot.log"
Content-Transfer-Encoding: base64

DQoNClUtQm9vdCAyMDEzLjA0IChKdW4gMTkgMjAxMyAtIDA4OjE3OjQwKQ0KDQpJMkM6ICAgcmVh
ZHkNCk1lbW9yeTogRUNDIGRpc2FibGVkDQpEUkFNOiAgMSBHaUINCldBUk5JTkc6IENhY2hlcyBu
b3QgZW5hYmxlZA0KTU1DOiAgIHp5bnFfc2RoY2k6IDANClNGOiBEZXRlY3RlZCBOMjVRMTI4QSB3
aXRoIHBhZ2Ugc2l6ZSAxMjggS2lCLCB0b3RhbCAzMiBNaUINCioqKiBXYXJuaW5nIC0gYmFkIENS
QywgdXNpbmcgZGVmYXVsdCBlbnZpcm9ubWVudA0KDQpJbjogICAgc2VyaWFsDQpPdXQ6ICAgc2Vy
aWFsDQpFcnI6ICAgc2VyaWFsDQpOZXQ6ICAgR2VtLmUwMDBiMDAwDQpIaXQgYW55IGtleSB0byBz
dG9wIGF1dG9ib290OiAgMyAICAggMiAICAggMSAICAggMCANClRGVFBpbmcgTGludXggdG8gUkFN
Li4uDQpHZW0uZTAwMGIwMDAgV2FpdGluZyBmb3IgUEhZIGF1dG8gbmVnb3RpYXRpb24gdG8gY29t
cGxldGUuLi4uLiBkb25lDQpVc2luZyBHZW0uZTAwMGIwMDAgZGV2aWNlDQpURlRQIGZyb20gc2Vy
dmVyIDEwLjEwLjcwLjEwMTsgb3VyIElQIGFkZHJlc3MgaXMgMTAuMTAuNzAuMTAyDQpGaWxlbmFt
ZSAndUltYWdlJy4NCkxvYWQgYWRkcmVzczogMHgzMDAwMDAwDQpMb2FkaW5nOiAqCCMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
DQoJICMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjDQoJICMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMNCgkg
NC4xIE1pQi9zDQpkb25lDQpCeXRlcyB0cmFuc2ZlcnJlZCA9IDI0NDkyNTYgKDI1NWY2OCBoZXgp
DQpHZW0uZTAwMGIwMDA6NyBpcyBjb25uZWN0ZWQgdG8gR2VtLmUwMDBiMDAwLiAgUmVjb25uZWN0
aW5nIHRvIEdlbS5lMDAwYjAwMA0KR2VtLmUwMDBiMDAwIFdhaXRpbmcgZm9yIFBIWSBhdXRvIG5l
Z290aWF0aW9uIHRvIGNvbXBsZXRlLi4uLi4gZG9uZQ0KVXNpbmcgR2VtLmUwMDBiMDAwIGRldmlj
ZQ0KVEZUUCBmcm9tIHNlcnZlciAxMC4xMC43MC4xMDE7IG91ciBJUCBhZGRyZXNzIGlzIDEwLjEw
LjcwLjEwMg0KRmlsZW5hbWUgJ2RldmljZXRyZWUuZHRiJy4NCkxvYWQgYWRkcmVzczogMHgyYTAw
MDAwDQpMb2FkaW5nOiAqCCMNCgkgMTI3LjkgS2lCL3MNCmRvbmUNCkJ5dGVzIHRyYW5zZmVycmVk
ID0gMjc1OSAoYWM3IGhleCkNCkdlbS5lMDAwYjAwMDo3IGlzIGNvbm5lY3RlZCB0byBHZW0uZTAw
MGIwMDAuICBSZWNvbm5lY3RpbmcgdG8gR2VtLmUwMDBiMDAwDQpHZW0uZTAwMGIwMDAgV2FpdGlu
ZyBmb3IgUEhZIGF1dG8gbmVnb3RpYXRpb24gdG8gY29tcGxldGUuLi4uLiBkb25lDQpVc2luZyBH
ZW0uZTAwMGIwMDAgZGV2aWNlDQpURlRQIGZyb20gc2VydmVyIDEwLjEwLjcwLjEwMTsgb3VyIElQ
IGFkZHJlc3MgaXMgMTAuMTAuNzAuMTAyDQpGaWxlbmFtZSAndXJhbWRpc2suaW1hZ2UuZ3onLg0K
TG9hZCBhZGRyZXNzOiAweDIwMDAwMDANCkxvYWRpbmc6ICoIIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMNCgkgIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMN
CgkgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMNCgkgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMNCgkgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMNCgkgIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMNCgkgNC4yIE1pQi9zDQpkb25lDQpCeXRlcyB0cmFuc2ZlcnJlZCA9
IDUyODQ2MjQgKDUwYTMxMCBoZXgpDQojIyBCb290aW5nIGtlcm5lbCBmcm9tIExlZ2FjeSBJbWFn
ZSBhdCAwMzAwMDAwMCAuLi4NCiAgIEltYWdlIE5hbWU6ICAgTGludXgtMy4xMS4wLXJjMy0wMDAw
MS1nY2VlZmVjZi0NCiAgIEltYWdlIFR5cGU6ICAgQVJNIExpbnV4IEtlcm5lbCBJbWFnZSAodW5j
b21wcmVzc2VkKQ0KICAgRGF0YSBTaXplOiAgICAyNDQ5MTkyIEJ5dGVzID0gMi4zIE1pQg0KICAg
TG9hZCBBZGRyZXNzOiAwMDAwODAwMA0KICAgRW50cnkgUG9pbnQ6ICAwMDAwODAwMA0KICAgVmVy
aWZ5aW5nIENoZWNrc3VtIC4uLiBPSw0KIyMgTG9hZGluZyBpbml0IFJhbWRpc2sgZnJvbSBMZWdh
Y3kgSW1hZ2UgYXQgMDIwMDAwMDAgLi4uDQogICBJbWFnZSBOYW1lOiAgIA0KICAgSW1hZ2UgVHlw
ZTogICBBUk0gTGludXggUkFNRGlzayBJbWFnZSAoZ3ppcCBjb21wcmVzc2VkKQ0KICAgRGF0YSBT
aXplOiAgICA1Mjg0NTYwIEJ5dGVzID0gNSBNaUINCiAgIExvYWQgQWRkcmVzczogMDAwMDAwMDAN
CiAgIEVudHJ5IFBvaW50OiAgMDAwMDAwMDANCiAgIFZlcmlmeWluZyBDaGVja3N1bSAuLi4gT0sN
CiMjIEZsYXR0ZW5lZCBEZXZpY2UgVHJlZSBibG9iIGF0IDAyYTAwMDAwDQogICBCb290aW5nIHVz
aW5nIHRoZSBmZHQgYmxvYiBhdCAweDAyYTAwMDAwDQogICBMb2FkaW5nIEtlcm5lbCBJbWFnZSAu
Li4gT0sNCk9LDQogICBMb2FkaW5nIFJhbWRpc2sgdG8gMWZhZjUwMDAsIGVuZCAxZmZmZjJkMCAu
Li4gT0sNCiAgIExvYWRpbmcgRGV2aWNlIFRyZWUgdG8gMWZhZjEwMDAsIGVuZCAxZmFmNGFjNiAu
Li4gT0sNCg0KU3RhcnRpbmcga2VybmVsIC4uLg0KDQpVbmNvbXByZXNzaW5nIExpbnV4Li4uIGRv
bmUsIGJvb3RpbmcgdGhlIGtlcm5lbC4NClsgICAgMC4wMDAwMDBdIEJvb3RpbmcgTGludXggb24g
cGh5c2ljYWwgQ1BVIDB4MA0KDVsgICAgMC4wMDAwMDBdIExpbnV4IHZlcnNpb24gMy4xMS4wLXJj
My0wMDAwMS1nY2VlZmVjZi1kaXJ0eSAoc29yZW5iQHhzamFuZHJlaXNseCkgKGdjYyB2ZXJzaW9u
IDQuNy4yIChTb3VyY2VyeSBDb2RlQmVuY2ggTGl0ZSAyMDEyLjA5LTEwNCkgKSAjOTMgU01QIFBS
RUVNUFQgVGh1IEF1ZyA4IDEwOjEyOjM5IFBEVCAyMDEzDQoNWyAgICAwLjAwMDAwMF0gQ1BVOiBB
Uk12NyBQcm9jZXNzb3IgWzQxM2ZjMDkwXSByZXZpc2lvbiAwIChBUk12NyksIGNyPTE4YzUzODdk
DQoNWyAgICAwLjAwMDAwMF0gQ1BVOiBQSVBUIC8gVklQVCBub25hbGlhc2luZyBkYXRhIGNhY2hl
LCBWSVBUIGFsaWFzaW5nIGluc3RydWN0aW9uIGNhY2hlDQoNWyAgICAwLjAwMDAwMF0gTWFjaGlu
ZTogWGlsaW54IFp5bnEgUGxhdGZvcm0sIG1vZGVsOiBaeW5xIFpDNzA2IERldmVsb3BtZW50IEJv
YXJkDQoNWyAgICAwLjAwMDAwMF0gYm9vdGNvbnNvbGUgW2Vhcmx5Y29uMF0gZW5hYmxlZA0KDVsg
ICAgMC4wMDAwMDBdIGNtYTogQ01BOiByZXNlcnZlZCAxNiBNaUIgYXQgMmU4MDAwMDANCg1bICAg
IDAuMDAwMDAwXSBNZW1vcnkgcG9saWN5OiBFQ0MgZGlzYWJsZWQsIERhdGEgY2FjaGUgd3JpdGVh
bGxvYw0KDVsgICAgMC4wMDAwMDBdIFBFUkNQVTogRW1iZWRkZWQgOSBwYWdlcy9jcHUgQGMxNDlj
MDAwIHMxNDcyMCByODE5MiBkMTM5NTIgdTM2ODY0DQoNWyAgICAwLjAwMDAwMF0gQnVpbHQgMSB6
b25lbGlzdHMgaW4gWm9uZSBvcmRlciwgbW9iaWxpdHkgZ3JvdXBpbmcgb24uICBUb3RhbCBwYWdl
czogMjYwNjI0DQoNWyAgICAwLjAwMDAwMF0gS2VybmVsIGNvbW1hbmQgbGluZTogY29uc29sZT10
dHlQUzAsMTE1MjAwIGVhcmx5cHJpbnRrDQoNWyAgICAwLjAwMDAwMF0gUElEIGhhc2ggdGFibGUg
ZW50cmllczogNDA5NiAob3JkZXI6IDIsIDE2Mzg0IGJ5dGVzKQ0KDVsgICAgMC4wMDAwMDBdIERl
bnRyeSBjYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDEzMTA3MiAob3JkZXI6IDcsIDUyNDI4OCBi
eXRlcykNCg1bICAgIDAuMDAwMDAwXSBJbm9kZS1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDY1
NTM2IChvcmRlcjogNiwgMjYyMTQ0IGJ5dGVzKQ0KDVsgICAgMC4wMDAwMDBdIE1lbW9yeTogMTAw
NTAxMksvMTA0ODU3NksgYXZhaWxhYmxlICg0ODg3SyBrZXJuZWwgY29kZSwgMzA3SyByd2RhdGEs
IDE1NjRLIHJvZGF0YSwgMzM4SyBpbml0LCA1Njk5SyBic3MsIDQzNTY0SyByZXNlcnZlZCwgMjcw
MzM2SyBoaWdobWVtKQ0KDVsgICAgMC4wMDAwMDBdIFZpcnR1YWwga2VybmVsIG1lbW9yeSBsYXlv
dXQ6DQoNWyAgICAwLjAwMDAwMF0gICAgIHZlY3RvciAgOiAweGZmZmYwMDAwIC0gMHhmZmZmMTAw
MCAgICggICA0IGtCKQ0KDVsgICAgMC4wMDAwMDBdICAgICBmaXhtYXAgIDogMHhmZmYwMDAwMCAt
IDB4ZmZmZTAwMDAgICAoIDg5NiBrQikNCg1bICAgIDAuMDAwMDAwXSAgICAgdm1hbGxvYyA6IDB4
ZjAwMDAwMDAgLSAweGZmMDAwMDAwICAgKCAyNDAgTUIpDQoNWyAgICAwLjAwMDAwMF0gICAgIGxv
d21lbSAgOiAweGMwMDAwMDAwIC0gMHhlZjgwMDAwMCAgICggNzYwIE1CKQ0KDVsgICAgMC4wMDAw
MDBdICAgICBwa21hcCAgIDogMHhiZmUwMDAwMCAtIDB4YzAwMDAwMDAgICAoICAgMiBNQikNCg1b
ICAgIDAuMDAwMDAwXSAgICAgbW9kdWxlcyA6IDB4YmYwMDAwMDAgLSAweGJmZTAwMDAwICAgKCAg
MTQgTUIpDQoNWyAgICAwLjAwMDAwMF0gICAgICAgLnRleHQgOiAweGMwMDA4MDAwIC0gMHhjMDY1
NTEzYyAgICg2NDUzIGtCKQ0KDVsgICAgMC4wMDAwMDBdICAgICAgIC5pbml0IDogMHhjMDY1NjAw
MCAtIDB4YzA2YWE5ODAgICAoIDMzOSBrQikNCg1bICAgIDAuMDAwMDAwXSAgICAgICAuZGF0YSA6
IDB4YzA2YWMwMDAgLSAweGMwNmY4YzIwICAgKCAzMDgga0IpDQoNWyAgICAwLjAwMDAwMF0gICAg
ICAgIC5ic3MgOiAweGMwNmY4YzIwIC0gMHhjMGM4OWFhNCAgICg1NzAwIGtCKQ0KDVsgICAgMC4w
MDAwMDBdIFByZWVtcHRpYmxlIGhpZXJhcmNoaWNhbCBSQ1UgaW1wbGVtZW50YXRpb24uDQoNWyAg
ICAwLjAwMDAwMF0gCVJDVSBsb2NrZGVwIGNoZWNraW5nIGlzIGVuYWJsZWQuDQoNWyAgICAwLjAw
MDAwMF0gCUFkZGl0aW9uYWwgcGVyLUNQVSBpbmZvIHByaW50ZWQgd2l0aCBzdGFsbHMuDQoNWyAg
ICAwLjAwMDAwMF0gCVJDVSByZXN0cmljdGluZyBDUFVzIGZyb20gTlJfQ1BVUz00IHRvIG5yX2Nw
dV9pZHM9Mi4NCg1bICAgIDAuMDAwMDAwXSBOUl9JUlFTOjE2IG5yX2lycXM6MTYgMTYNCg1bICAg
IDAuMDAwMDAwXSBzbGNyIG1hcHBlZCB0byBmMDAwNDAwMA0KDVsgICAgMC4wMDAwMDBdIFp5bnEg
Y2xvY2sgaW5pdA0KDVsgICAgMC4wMDAwMDBdIHNjaGVkX2Nsb2NrOiAzMiBiaXRzIGF0IDMzM01I
eiwgcmVzb2x1dGlvbiAzbnMsIHdyYXBzIGV2ZXJ5IDEyODg0bXMNCg1bICAgIDAuMDAwMDAwXSAt
LS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NCg1bICAgIDAuMDAwMDAwXSBXQVJO
SU5HOiBDUFU6IDAgUElEOiAwIGF0IGtlcm5lbC9zbXAuYzoyNDQgc21wX2NhbGxfZnVuY3Rpb25f
c2luZ2xlKzB4YWMvMHgxZTgoKQ0KDVsgICAgMC4wMDAwMDBdIE1vZHVsZXMgbGlua2VkIGluOg0K
DVsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVk
IDMuMTEuMC1yYzMtMDAwMDEtZ2NlZWZlY2YtZGlydHkgIzkzDQoNWyAgICAwLjAwMDAwMF0gWzxj
MDAxNmE4OD5dICh1bndpbmRfYmFja3RyYWNlKzB4MC8weDEyOCkgZnJvbSBbPGMwMDEyZDU4Pl0g
KHNob3dfc3RhY2srMHgyMC8weDI0KQ0KDVsgICAgMC4wMDAwMDBdIFs8YzAwMTJkNTg+XSAoc2hv
d19zdGFjaysweDIwLzB4MjQpIGZyb20gWzxjMDQ2NTg1OD5dIChkdW1wX3N0YWNrKzB4ODAvMHhj
NCkNCg1bICAgIDAuMDAwMDAwXSBbPGMwNDY1ODU4Pl0gKGR1bXBfc3RhY2srMHg4MC8weGM0KSBm
cm9tIFs8YzAwMjNhODA+XSAod2Fybl9zbG93cGF0aF9jb21tb24rMHg3OC8weDljKQ0KDVsgICAg
MC4wMDAwMDBdIFs8YzAwMjNhODA+XSAod2Fybl9zbG93cGF0aF9jb21tb24rMHg3OC8weDljKSBm
cm9tIFs8YzAwMjNhZDA+XSAod2Fybl9zbG93cGF0aF9udWxsKzB4MmMvMHgzNCkNCg1bICAgIDAu
MDAwMDAwXSBbPGMwMDIzYWQwPl0gKHdhcm5fc2xvd3BhdGhfbnVsbCsweDJjLzB4MzQpIGZyb20g
WzxjMDA4NGQ1OD5dIChzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUrMHhhYy8weDFlOCkNCg1bICAg
IDAuMDAwMDAwXSBbPGMwMDg0ZDU4Pl0gKHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZSsweGFjLzB4
MWU4KSBmcm9tIFs8YzAwODU1MmM+XSAoc21wX2NhbGxfZnVuY3Rpb25fYW55KzB4ZTAvMHgxMWMp
DQoNWyAgICAwLjAwMDAwMF0gWzxjMDA4NTUyYz5dIChzbXBfY2FsbF9mdW5jdGlvbl9hbnkrMHhl
MC8weDExYykgZnJvbSBbPGMwMDc1NDU4Pl0gKGNsb2NrZXZlbnRzX3NldF9tb2RlKzB4NDAvMHg3
YykNCg1bICAgIDAuMDAwMDAwXSBbPGMwMDc1NDU4Pl0gKGNsb2NrZXZlbnRzX3NldF9tb2RlKzB4
NDAvMHg3YykgZnJvbSBbPGMwMDc1NGI0Pl0gKGNsb2NrZXZlbnRzX3NodXRkb3duKzB4MjAvMHgz
MCkNCg1bICAgIDAuMDAwMDAwXSBbPGMwMDc1NGI0Pl0gKGNsb2NrZXZlbnRzX3NodXRkb3duKzB4
MjAvMHgzMCkgZnJvbSBbPGMwMDc1ODUwPl0gKGNsb2NrZXZlbnRzX2V4Y2hhbmdlX2RldmljZSsw
eDk0LzB4YjgpDQoNWyAgICAwLjAwMDAwMF0gWzxjMDA3NTg1MD5dIChjbG9ja2V2ZW50c19leGNo
YW5nZV9kZXZpY2UrMHg5NC8weGI4KSBmcm9tIFs8YzAwNzVmYjA+XSAodGlja19jaGVja19uZXdf
ZGV2aWNlKzB4YzgvMHgxMWMpDQoNWyAgICAwLjAwMDAwMF0gWzxjMDA3NWZiMD5dICh0aWNrX2No
ZWNrX25ld19kZXZpY2UrMHhjOC8weDExYykgZnJvbSBbPGMwMDc1MTVjPl0gKGNsb2NrZXZlbnRz
X3JlZ2lzdGVyX2RldmljZSsweGMwLzB4MTM0KQ0KDVsgICAgMC4wMDAwMDBdIFs8YzAwNzUxNWM+
XSAoY2xvY2tldmVudHNfcmVnaXN0ZXJfZGV2aWNlKzB4YzAvMHgxMzQpIGZyb20gWzxjMDA3NTc1
OD5dIChjbG9ja2V2ZW50c19jb25maWdfYW5kX3JlZ2lzdGVyKzB4MmMvMHgzMCkNCg1bICAgIDAu
MDAwMDAwXSBbPGMwMDc1NzU4Pl0gKGNsb2NrZXZlbnRzX2NvbmZpZ19hbmRfcmVnaXN0ZXIrMHgy
Yy8weDMwKSBmcm9tIFs8YzAzN2EyNGM+XSAoZ3RfY2xvY2tldmVudHNfaW5pdCsweDhjLzB4YjQp
DQoNWyAgICAwLjAwMDAwMF0gWzxjMDM3YTI0Yz5dIChndF9jbG9ja2V2ZW50c19pbml0KzB4OGMv
MHhiNCkgZnJvbSBbPGMwNjgyMGJjPl0gKGdsb2JhbF90aW1lcl9vZl9yZWdpc3RlcisweDFlNC8w
eDI5NCkNCg1bICAgIDAuMDAwMDAwXSBbPGMwNjgyMGJjPl0gKGdsb2JhbF90aW1lcl9vZl9yZWdp
c3RlcisweDFlNC8weDI5NCkgZnJvbSBbPGMwNjgxYTdjPl0gKGNsb2Nrc291cmNlX29mX2luaXQr
MHgyYy8weDU0KQ0KDVsgICAgMC4wMDAwMDBdIFs8YzA2ODFhN2M+XSAoY2xvY2tzb3VyY2Vfb2Zf
aW5pdCsweDJjLzB4NTQpIGZyb20gWzxjMDY1ZWI5OD5dICh6eW5xX3RpbWVyX2luaXQrMHgxNC8w
eDE4KQ0KDVsgICAgMC4wMDAwMDBdIFs8YzA2NWViOTg+XSAoenlucV90aW1lcl9pbml0KzB4MTQv
MHgxOCkgZnJvbSBbPGMwNjU5ZWM4Pl0gKHRpbWVfaW5pdCsweDI0LzB4MzQpDQoNWyAgICAwLjAw
MDAwMF0gWzxjMDY1OWVjOD5dICh0aW1lX2luaXQrMHgyNC8weDM0KSBmcm9tIFs8YzA2NTY3NzQ+
XSAoc3RhcnRfa2VybmVsKzB4MWNjLzB4MzJjKQ0KDVsgICAgMC4wMDAwMDBdIFs8YzA2NTY3NzQ+
XSAoc3RhcnRfa2VybmVsKzB4MWNjLzB4MzJjKSBmcm9tIFs8MDAwMDgwNzQ+XSAoMHg4MDc0KQ0K
DVsgICAgMC4wMDAwMDBdIC0tLVsgZW5kIHRyYWNlIDFiNzViMzFhMjcxOWVkMWMgXS0tLQ0KDVsg
ICAgMC4wMDAwMDBdIHR0YzAgIzAgYXQgZjAwMDYwMDAsIGlycT00Mw0KDVsgICAgMC4wMDAwMDBd
IENvbnNvbGU6IGNvbG91ciBkdW1teSBkZXZpY2UgODB4MzANCg1bICAgIDAuMDAwMDAwXSBMb2Nr
IGRlcGVuZGVuY3kgdmFsaWRhdG9yOiBDb3B5cmlnaHQgKGMpIDIwMDYgUmVkIEhhdCwgSW5jLiwg
SW5nbyBNb2xuYXINCg1bICAgIDAuMDAwMDAwXSAuLi4gTUFYX0xPQ0tERVBfU1VCQ0xBU1NFUzog
IDgNCg1bICAgIDAuMDAwMDAwXSAuLi4gTUFYX0xPQ0tfREVQVEg6ICAgICAgICAgIDQ4DQoNWyAg
ICAwLjAwMDAwMF0gLi4uIE1BWF9MT0NLREVQX0tFWVM6ICAgICAgICA4MTkxDQoNWyAgICAwLjAw
MDAwMF0gLi4uIENMQVNTSEFTSF9TSVpFOiAgICAgICAgICA0MDk2DQoNWyAgICAwLjAwMDAwMF0g
Li4uIE1BWF9MT0NLREVQX0VOVFJJRVM6ICAgICAxNjM4NA0KDVsgICAgMC4wMDAwMDBdIC4uLiBN
QVhfTE9DS0RFUF9DSEFJTlM6ICAgICAgMzI3NjgNCg1bICAgIDAuMDAwMDAwXSAuLi4gQ0hBSU5I
QVNIX1NJWkU6ICAgICAgICAgIDE2Mzg0DQoNWyAgICAwLjAwMDAwMF0gIG1lbW9yeSB1c2VkIGJ5
IGxvY2sgZGVwZW5kZW5jeSBpbmZvOiAzNjk1IGtCDQoNWyAgICAwLjAwMDAwMF0gIHBlciB0YXNr
LXN0cnVjdCBtZW1vcnkgZm9vdHByaW50OiAxMTUyIGJ5dGVzDQoNWyAgICAwLjI2OTUzM10gQ2Fs
aWJyYXRpbmcgZGVsYXkgbG9vcC4uLiAxMzI1LjQ2IEJvZ29NSVBTIChscGo9NjYyNzMyOCkNCg1b
ICAgIDAuMzEyMTU0XSBwaWRfbWF4OiBkZWZhdWx0OiAzMjc2OCBtaW5pbXVtOiAzMDENCg1bICAg
IDAuMzE1MTkyXSBNb3VudC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDUxMg0KDVsgICAgMC4z
MjYzNzBdIENQVTogVGVzdGluZyB3cml0ZSBidWZmZXIgY29oZXJlbmN5OiBvaw0KDVsgICAgMC4z
MjY1MjFdIGZ0cmFjZTogYWxsb2NhdGluZyAxNjE0NCBlbnRyaWVzIGluIDQ4IHBhZ2VzDQoNWyAg
ICAwLjM2NzAwOV0gQ1BVMDogdGhyZWFkIC0xLCBjcHUgMCwgc29ja2V0IDAsIG1waWRyIDgwMDAw
MDAwDQoNWyAgICAwLjM2NzI5OF0gU2V0dGluZyB1cCBzdGF0aWMgaWRlbnRpdHkgbWFwIGZvciAw
eGMwNDZjMzE4IC0gMHhjMDQ2YzM3MA0KDVsgICAgMC40MzAzMDBdIENQVTE6IEJvb3RlZCBzZWNv
bmRhcnkgcHJvY2Vzc29yDQoNWyAgICAwLjUxNzI4Ml0gQ1BVMTogdGhyZWFkIC0xLCBjcHUgMSwg
c29ja2V0IDAsIG1waWRyIDgwMDAwMDAxDQoNWyAgICAwLjUxODYwNV0gQnJvdWdodCB1cCAyIENQ
VXMNCg1bICAgIDAuNTI2MTIwXSBTTVA6IFRvdGFsIG9mIDIgcHJvY2Vzc29ycyBhY3RpdmF0ZWQg
KDI2NTcuNDggQm9nb01JUFMpLg0KDVsgICAgMC41MzI1NDRdIENQVTogQWxsIENQVShzKSBzdGFy
dGVkIGluIFNWQyBtb2RlLg0KDVsgICAgMC41NDE3MDldIGRldnRtcGZzOiBpbml0aWFsaXplZA0K
DVsgICAgMC41NjAwOTddIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMTYNCg1bICAg
IDAuNTY2MDA0XSBETUE6IHByZWFsbG9jYXRlZCAyNTYgS2lCIHBvb2wgZm9yIGF0b21pYyBjb2hl
cmVudCBhbGxvY2F0aW9ucw0KDVsgICAgMC41NzkwMzddIEwzMTAgY2FjaGUgY29udHJvbGxlciBl
bmFibGVkDQoNWyAgICAwLjU3OTA3NF0gbDJ4MDogOCB3YXlzLCBDQUNIRV9JRCAweDQxMDAwMGM4
LCBBVVhfQ1RSTCAweDcyMzYwMDAwLCBDYWNoZSBzaXplOiA1MjQyODggQg0KDVsgICAgMC41OTM4
NjJdIGh3LWJyZWFrcG9pbnQ6IGZvdW5kIDUgKCsxIHJlc2VydmVkKSBicmVha3BvaW50IGFuZCAx
IHdhdGNocG9pbnQgcmVnaXN0ZXJzLg0KDVsgICAgMC41OTYzNzddIGh3LWJyZWFrcG9pbnQ6IG1h
eGltdW0gd2F0Y2hwb2ludCBzaXplIGlzIDQgYnl0ZXMuDQoNWyAgICAwLjY3Njk0M10gYmlvOiBj
cmVhdGUgc2xhYiA8YmlvLTA+IGF0IDANCg1bICAgIDAuNjgyNjI0XSBTQ1NJIHN1YnN5c3RlbSBp
bml0aWFsaXplZA0KDVsgICAgMC42ODU0MjZdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVy
ZmFjZSBkcml2ZXIgdXNiZnMNCg1bICAgIDAuNjg3MDAyXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5l
dyBpbnRlcmZhY2UgZHJpdmVyIGh1Yg0KDVsgICAgMC42OTI2MjFdIHVzYmNvcmU6IHJlZ2lzdGVy
ZWQgbmV3IGRldmljZSBkcml2ZXIgdXNiDQoNWyAgICAwLjcwNzMxMV0gU3dpdGNoZWQgdG8gY2xv
Y2tzb3VyY2UgYXJtX2dsb2JhbF90aW1lcg0KDVsgICAgMC44ODIxNTRdIE5FVDogUmVnaXN0ZXJl
ZCBwcm90b2NvbCBmYW1pbHkgMg0KDVsgICAgMC44ODc4MTldIFRDUCBlc3RhYmxpc2hlZCBoYXNo
IHRhYmxlIGVudHJpZXM6IDgxOTIgKG9yZGVyOiA0LCA2NTUzNiBieXRlcykNCg1bICAgIDAuODg5
NzQxXSBUQ1AgYmluZCBoYXNoIHRhYmxlIGVudHJpZXM6IDgxOTIgKG9yZGVyOiA2LCAyOTQ5MTIg
Ynl0ZXMpDQoNWyAgICAwLjg5OTY0Ml0gVENQOiBIYXNoIHRhYmxlcyBjb25maWd1cmVkIChlc3Rh
Ymxpc2hlZCA4MTkyIGJpbmQgODE5MikNCg1bICAgIDAuOTAyNTk2XSBUQ1A6IHJlbm8gcmVnaXN0
ZXJlZA0KDVsgICAgMC45MDU1ODFdIFVEUCBoYXNoIHRhYmxlIGVudHJpZXM6IDUxMiAob3JkZXI6
IDMsIDQwOTYwIGJ5dGVzKQ0KDVsgICAgMC45MTIwMDZdIFVEUC1MaXRlIGhhc2ggdGFibGUgZW50
cmllczogNTEyIChvcmRlcjogMywgNDA5NjAgYnl0ZXMpDQoNWyAgICAwLjkxOTY2N10gTkVUOiBS
ZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxDQoNWyAgICAwLjkyNDA0MV0gUlBDOiBSZWdpc3Rl
cmVkIG5hbWVkIFVOSVggc29ja2V0IHRyYW5zcG9ydCBtb2R1bGUuDQoNWyAgICAwLjkyODc5Nl0g
UlBDOiBSZWdpc3RlcmVkIHVkcCB0cmFuc3BvcnQgbW9kdWxlLg0KDVsgICAgMC45MzI5MDZdIFJQ
QzogUmVnaXN0ZXJlZCB0Y3AgdHJhbnNwb3J0IG1vZHVsZS4NCg1bICAgIDAuOTM3NzI4XSBSUEM6
IFJlZ2lzdGVyZWQgdGNwIE5GU3Y0LjEgYmFja2NoYW5uZWwgdHJhbnNwb3J0IG1vZHVsZS4NCg1b
ICAgIDAuOTQ1Mzc4XSBUcnlpbmcgdG8gdW5wYWNrIHJvb3RmcyBpbWFnZSBhcyBpbml0cmFtZnMu
Li4NCg1bICAgIDEuNzY2OTM2XSBGcmVlaW5nIGluaXRyZCBtZW1vcnk6IDUxNjBLIChkZmFmNTAw
MCAtIGRmZmZmMDAwKQ0KDVsgICAgMS43Nzk5MzddIGJvdW5jZSBwb29sIHNpemU6IDY0IHBhZ2Vz
DQoNWyAgICAxLjc4NDA1MF0gamZmczI6IHZlcnNpb24gMi4yLiAoTkFORCkgKFNVTU1BUlkpICDC
qSAyMDAxLTIwMDYgUmVkIEhhdCwgSW5jLg0KDVsgICAgMS43ODYyNjZdIG1zZ21uaSBoYXMgYmVl
biBzZXQgdG8gMTQ3Ng0KDVsgICAgMS44MTAzMTBdIGlvIHNjaGVkdWxlciBub29wIHJlZ2lzdGVy
ZWQNCg1bICAgIDEuODEwMzQzXSBpbyBzY2hlZHVsZXIgZGVhZGxpbmUgcmVnaXN0ZXJlZA0KDVsg
ICAgMS44MTMyMTRdIGlvIHNjaGVkdWxlciBjZnEgcmVnaXN0ZXJlZCAoZGVmYXVsdCkNCg1bICAg
IDEuODMzODA2XSBlMDAw8VsgICAgMS44MzU3OTldIGNvbnNvbGUgW3R0eVBTMF0gZW5hYmxlZCwg
Ym9vdGNvbnNvbGUgZGlzYWJsZWQNClsgICAgMS44MzU3OTldIGNvbnNvbGUgW3R0eVBTMF0gZW5h
YmxlZCwgYm9vdGNvbnNvbGUgZGlzYWJsZWQNCg1bICAgIDEuODc5OTA1XSBicmQ6IG1vZHVsZSBs
b2FkZWQNClsgICAgMS45MDQyMTRdIGxvb3A6IG1vZHVsZSBsb2FkZWQNClsgICAgMS45MjQ5MDRd
IGVoY2lfaGNkOiBVU0IgMi4wICdFbmhhbmNlZCcgSG9zdCBDb250cm9sbGVyIChFSENJKSBEcml2
ZXINClsgICAgMS45MzI4OThdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2
ZXIgdXNiLXN0b3JhZ2UNClsgICAgMS45NDE2MjldIG1vdXNlZGV2OiBQUy8yIG1vdXNlIGRldmlj
ZSBjb21tb24gZm9yIGFsbCBtaWNlDQpbICAgIDEuOTQ5NTc2XSBpMmMgL2RldiBlbnRyaWVzIGRy
aXZlcg0KWyAgICAxLjk1Njg0MV0gY3B1aWRsZTogdXNpbmcgZ292ZXJub3IgbGFkZGVyDQpbICAg
IDEuOTYwOTMxXSBjcHVpZGxlOiB1c2luZyBnb3Zlcm5vciBtZW51DQpbICAgIDEuOTY0NzUyXSBY
aWxpbnggWnlucSBDcHVJZGxlIERyaXZlciBzdGFydGVkDQpbICAgIDEuOTcwNDgxXSBzZGhjaTog
U2VjdXJlIERpZ2l0YWwgSG9zdCBDb250cm9sbGVyIEludGVyZmFjZSBkcml2ZXINClsgICAgMS45
NzY1MjRdIHNkaGNpOiBDb3B5cmlnaHQoYykgUGllcnJlIE9zc21hbg0KWyAgICAxLjk4MTE2OF0g
c2RoY2ktcGx0Zm06IFNESENJIHBsYXRmb3JtIGFuZCBPRiBkcml2ZXIgaGVscGVyDQpbICAgIDEu
OTg5MTI2XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIHVzYmhpZA0K
WyAgICAxLjk5NDU2N10gdXNiaGlkOiBVU0IgSElEIGNvcmUgZHJpdmVyDQpbICAgIDEuOTk5MjM2
XSBUQ1A6IGN1YmljIHJlZ2lzdGVyZWQNClsgICAgMi4wMDI0NTZdIE5FVDogUmVnaXN0ZXJlZCBw
cm90b2NvbCBmYW1pbHkgMTcNClsgICAgMi4wMDY5NTBdIFZGUCBzdXBwb3J0IHYwLjM6IGltcGxl
bWVudG9yIDQxIGFyY2hpdGVjdHVyZSAzIHBhcnQgMzAgdmFyaWFudCA5IHJldiA0DQpbICAgIDIu
MDE0NTU1XSBSZWdpc3RlcmluZyBTV1AvU1dQQiBlbXVsYXRpb24gaGFuZGxlcg0KWyAgICAyLjAy
Mzk0Ml0gZHJpdmVycy9ydGMvaGN0b3N5cy5jOiB1bmFibGUgdG8gb3BlbiBydGMgZGV2aWNlIChy
dGMwKQ0KWyAgICAyLjA2MzM3Nl0gRnJlZWluZyB1bnVzZWQga2VybmVsIG1lbW9yeTogMzM2SyAo
YzA2NTYwMDAgLSBjMDZhYTAwMCkNCg0KV2VsY29tZSB0byAbWzFtQnVpbGRyb290IDIwMTMuMDgt
Z2l0G1swbSENCg0KU3RhcnRpbmcgTWVkaWEgRGlyZWN0b3J5Li4uICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KU3RhcnRpbmcgRmlsZSBTeXN0ZW0g
Q2hlY2sgb24gUm9vdCBEZXZpY2UuLi4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IA0KU3RhcnRpbmcgUmVtb3VudCBBUEkgVkZTLi4uICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIA0KU3RhcnRlZCBSdW50aW1lIERpcmVjdG9yeSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbG1sxOzMybSAgT0sgIBtb
MG1dDQpTdGFydGVkIExvY2sgRGlyZWN0b3J5ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFsbWzE7MzJtICBPSyAgG1swbV0NClN0YXJ0ZWQgU2V0IFVwIEFk
ZGl0aW9uYWwgQmluYXJ5IEZvcm1hdHMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgWxtb
MTszMm0gIE9LICAbWzBtXQ0KU3RhcnRpbmcgQXBwbHkgS2VybmVsIFZhcmlhYmxlcy4uLiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KU3RhcnRpbmcgSm91cm5h
bCBTZXJ2aWNlLi4uICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIA0KU3RhcnRlZCBKb3VybmFsIFNlcnZpY2UgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBbG1sxOzMybSAgT0sgIBtbMG1dDQpTdGFydGVkIFBPU0lY
IE1lc3NhZ2UgUXVldWUgRmlsZSBTeXN0ZW0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFsbWzE7MzJtICBPSyAgG1swbV0NClN0YXJ0ZWQgSHVnZSBQYWdlcyBGaWxlIFN5c3RlbSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgWxtbMTszMm0gIE9LICAbWzBtXQ0K
U3RhcnRlZCBTZWN1cml0eSBGaWxlIFN5c3RlbSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBbG1sxOzMybSAgT0sgIBtbMG1dDQpTdGFydGluZyBEZWJ1ZyBGaWxlIFN5
c3RlbS4uLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
DQpTdGFydGVkIExvYWQgS2VybmVsIE1vZHVsZXMgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFsbWzE7MzJtICBPSyAgG1swbV0NClN0YXJ0ZWQgRlVTRSBDb250cm9s
IEZpbGUgU3lzdGVtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgWxtbMTsz
Mm0gIE9LICAbWzBtXQ0KU3RhcnRlZCBDb25maWd1cmF0aW9uIEZpbGUgU3lzdGVtICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbG1sxOzMybSAgT0sgIBtbMG1dDQpTdGFydGlu
ZyBTZXR1cCBWaXJ0dWFsIENvbnNvbGUuLi4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgDQpTdGFydGluZyB1ZGV2IENvbGRwbHVnIGFsbCBEZXZpY2VzLi4uICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQpTdGFydGluZyB1ZGV2IEtl
cm5lbCBEZXZpY2UgTWFuYWdlci4uLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgDQpTdGFydGVkIE1lZGlhIERpcmVjdG9yeSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFsbWzE7MzJtICBPSyAgG1swbV0NClsgICAxNC40NTU4Mjhd
IHVkZXZkWzQ3MF06IHN0YXJ0aW5nIHZlcnNpb24gMTgyDQpTdGFydGVkIHVkZXYgS2VybmVsIERl
dmljZSBNYW5hZ2VyICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFsbWzE7MzJt
ICBPSyAgG1swbV0NClN0YXJ0ZWQgRmlsZSBTeXN0ZW0gQ2hlY2sgb24gUm9vdCBEZXZpY2UgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgWxtbMTszMm0gIE9LICAbWzBtXQ0KU3RhcnRlZCBS
ZW1vdW50IEFQSSBWRlMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBbG1sxOzMybSAgT0sgIBtbMG1dDQpTdGFydGVkIEFwcGx5IEtlcm5lbCBWYXJpYWJsZXMg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFsbWzE7MzJtICBPSyAgG1sw
bV0NClN0YXJ0ZWQgRGVidWcgRmlsZSBTeXN0ZW0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgWxtbMTszMm0gIE9LICAbWzBtXQ0KU3RhcnRlZCBTZXR1cCBWaXJ0
dWFsIENvbnNvbGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbG1sx
OzMybSAgT0sgIBtbMG1dDQpTdGFydGluZyBSZW1vdW50IFJvb3QgRlMuLi4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQpTdGFydGVkIFJlbW91bnQg
Um9vdCBGUyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFsb
WzE7MzJtICBPSyAgG1swbV0NClN0YXJ0aW5nIExvYWQgUmFuZG9tIFNlZWQuLi4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANClN0YXJ0aW5nIFJlY3Jl
YXRlIFZvbGF0aWxlIEZpbGVzIGFuZCBEaXJlY3Rvcmllcy4uLiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICANClN0YXJ0ZWQgdWRldiBDb2xkcGx1ZyBhbGwgRGV2aWNlcyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgWxtbMTszMm0gIE9LICAbWzBtXQ0KU3RhcnRlZCBMb2Fk
IFJhbmRvbSBTZWVkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBbG1sxOzMybSAgT0sgIBtbMG1dDQpTdGFydGVkIFJlY3JlYXRlIFZvbGF0aWxlIEZpbGVzIGFu
ZCBEaXJlY3RvcmllcyAgICAgICAgICAgICAgICAgICAgICAgIFsbWzE7MzJtICBPSyAgG1swbV0N
ClN0YXJ0aW5nIFBlcm1pdCBVc2VyIFNlc3Npb25zLi4uICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANClN0YXJ0aW5nIExvZ2luIFNlcnZpY2UuLi4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANClN0YXJ0aW5n
IEQtQnVzIFN5c3RlbSBNZXNzYWdlIEJ1cy4uLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICANClN0YXJ0ZWQgUGVybWl0IFVzZXIgU2Vzc2lvbnMgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgWxtbMTszMm0gIE9LICAbWzBtXQ0KU3RhcnRp
bmcgU2VyaWFsIEdldHR5IG9uIHR0eVBTMC4uLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIA0KU3RhcnRlZCBTZXJpYWwgR2V0dHkgb24gdHR5UFMwICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbG1sxOzMybSAgT0sgIBtbMG1dDQpTdGFy
dGVkIEQtQnVzIFN5c3RlbSBNZXNzYWdlIEJ1cyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFsbWzE7MzJtICBPSyAgG1swbV0NClN0YXJ0ZWQgTG9naW4gU2VydmljZSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgWxtbMTszMm0gIE9L
ICAbWzBtXQ0KDQ0KWnlucSBCdXN5Ym94IFN5c3RlbQ0KDXp5bnEgbG9naW46IHJvb3QNClBhc3N3
b3JkOiANCiMgbHMNCiMgY2F0IC9wcm9jL2ludA0jIGNhdCAvcHJvYy9pbnRlcnJ1cHRzIBtbSg0K
ICAgICAgICAgICBDUFUwICAgICAgIENQVTEgICAgICAgDQogMjc6ICAgICAgICAyNjIgICAgICAg
ICAgMSAgICAgICBHSUMgIDI3ICBndA0KIDI5OiAgICAgICAgNzM5ICAgICAgICA3MzIgICAgICAg
R0lDICAyOSAgdHdkDQogNDM6ICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICBHSUMgIDQzICB0
dGNfY2xvY2tldmVudA0KIDgyOiAgICAgICAgMjE3ICAgICAgICAgIDAgICAgICAgR0lDICA4MiAg
eHVhcnRwcw0KSVBJMDogICAgICAgICAgMCAgICAgICAgICAwICBDUFUgd2FrZXVwIGludGVycnVw
dHMNCklQSTE6ICAgICAgICAgIDAgICAgICAgICA1MSAgVGltZXIgYnJvYWRjYXN0IGludGVycnVw
dHMNCklQSTI6ICAgICAgIDEyMzYgICAgICAgMTI5MSAgUmVzY2hlZHVsaW5nIGludGVycnVwdHMN
CklQSTM6ICAgICAgICAgIDAgICAgICAgICAgMCAgRnVuY3Rpb24gY2FsbCBpbnRlcnJ1cHRzDQpJ
UEk0OiAgICAgICAgIDg2ICAgICAgICAgNzYgIFNpbmdsZSBmdW5jdGlvbiBjYWxsIGludGVycnVw
dHMNCklQSTU6ICAgICAgICAgIDAgICAgICAgICAgMCAgQ1BVIHN0b3AgaW50ZXJydXB0cw0KRXJy
OiAgICAgICAgICAwDQojIGNhdCAvcHJvYy90aW0HDSMgY2F0IC9wcm9jL3RpbWVyXxtbSmwNIyBj
YXQgL3Byb2MvdGltZXJfbGlzdCAbW0oNClRpbWVyIExpc3QgVmVyc2lvbjogdjAuNw0KSFJUSU1F
Ul9NQVhfQ0xPQ0tfQkFTRVM6IDQNCm5vdyBhdCA4NzI4Mjk0NTk0OSBuc2Vjcw0KDQpjcHU6IDAN
CiBjbG9jayAwOg0KICAuYmFzZTogICAgICAgYzE0OWM3MTgNCiAgLmluZGV4OiAgICAgIDANCiAg
LnJlc29sdXRpb246IDEgbnNlY3MNCiAgLmdldF90aW1lOiAgIGt0aW1lX2dldA0KICAub2Zmc2V0
OiAgICAgMCBuc2Vjcw0KYWN0aXZlIHRpbWVyczoNCiAjMDogPGMxNDllNjcwPiwgbWVudV9ocnRp
bWVyX25vdGlmeSwgUzowMSwgaHJ0aW1lcl9zdGFydCwgc3dhcHBlci8wLzANCiAjIGV4cGlyZXMg
YXQgODcyODMwNzEyNDQtODcyODMwNzEyNDQgbnNlY3MgW2luIDEyNTk4OCB0byAxMjU5ODggbnNl
Y3NdDQogIzE6IDxjMTQ5Y2FjOD4sIHRpY2tfc2NoZWRfdGltZXIsIFM6MDEsIGhydGltZXJfc3Rh
cnQsIHN3YXBwZXIvMC8wDQogIyBleHBpcmVzIGF0IDk2MDgwMDAwMDAwLTk2MDgwMDAwMDAwIG5z
ZWNzIFtpbiA4Nzk3MDU0NzQ0IHRvIDg3OTcwNTQ3NDQgbnNlY3NdDQogY2xvY2sgMToNCiAgLmJh
c2U6ICAgICAgIGMxNDljNzUwDQogIC5pbmRleDogICAgICAxDQogIC5yZXNvbHV0aW9uOiAxIG5z
ZWNzDQogIC5nZXRfdGltZTogICBrdGltZV9nZXRfcmVhbA0KICAub2Zmc2V0OiAgICAgMCBuc2Vj
cw0KYWN0aXZlIHRpbWVyczoNCiBjbG9jayAyOg0KICAuYmFzZTogICAgICAgYzE0OWM3ODgNCiAg
LmluZGV4OiAgICAgIDINCiAgLnJlc29sdXRpb246IDEgbnNlY3MNCiAgLmdldF90aW1lOiAgIGt0
aW1lX2dldF9ib290dGltZQ0KICAub2Zmc2V0OiAgICAgMCBuc2Vjcw0KYWN0aXZlIHRpbWVyczoN
CiBjbG9jayAzOg0KICAuYmFzZTogICAgICAgYzE0OWM3YzANCiAgLmluZGV4OiAgICAgIDMNCiAg
LnJlc29sdXRpb246IDEgbnNlY3MNCiAgLmdldF90aW1lOiAgIGt0aW1lX2dldF9jbG9ja3RhaQ0K
ICAub2Zmc2V0OiAgICAgMCBuc2Vjcw0KYWN0aXZlIHRpbWVyczoNCiAgLmV4cGlyZXNfbmV4dCAg
IDogODcyODMyMzg1NTQgbnNlY3MNCiAgLmhyZXNfYWN0aXZlICAgIDogMQ0KICAubnJfZXZlbnRz
ICAgICAgOiA3ODINCiAgLm5yX3JldHJpZXMgICAgIDogMQ0KICAubnJfaGFuZ3MgICAgICAgOiAw
DQogIC5tYXhfaGFuZ190aW1lICA6IDAgbnNlY3MNCiAgLm5vaHpfbW9kZSAgICAgIDogMg0KICAu
bGFzdF90aWNrICAgICAgOiA4NzI4MDAwMDAwMCBuc2Vjcw0KICAudGlja19zdG9wcGVkICAgOiAx
DQogIC5pZGxlX2ppZmZpZXMgICA6IDQyOTQ5NDYwMjMNCiAgLmlkbGVfY2FsbHMgICAgIDogMTU0
Mw0KICAuaWRsZV9zbGVlcHMgICAgOiAyNTMNCiAgLmlkbGVfZW50cnl0aW1lIDogODcyODMwODM4
NzEgbnNlY3MNCiAgLmlkbGVfd2FrZXRpbWUgIDogODcyODMwNzQyMjAgbnNlY3MNCiAgLmlkbGVf
ZXhpdHRpbWUgIDogODcyNzQxMjM0MTEgbnNlY3MNCiAgLmlkbGVfc2xlZXB0aW1lIDogODQzMTMw
OTg1NDMgbnNlY3MNCiAgLmlvd2FpdF9zbGVlcHRpbWU6IDAgbnNlY3MNCiAgLmxhc3RfamlmZmll
cyAgIDogNDI5NDk0NjAyNA0KICAubmV4dF9qaWZmaWVzICAgOiA0Mjk0OTQ2OTA0DQogIC5pZGxl
X2V4cGlyZXMgICA6IDk2MDgwMDAwMDAwIG5zZWNzDQpqaWZmaWVzOiA0Mjk0OTQ2MDI0DQoNCmNw
dTogMQ0KIGNsb2NrIDA6DQogIC5iYXNlOiAgICAgICBjMTRhNTcxOA0KICAuaW5kZXg6ICAgICAg
MA0KICAucmVzb2x1dGlvbjogMSBuc2Vjcw0KICAuZ2V0X3RpbWU6ICAga3RpbWVfZ2V0DQogIC5v
ZmZzZXQ6ICAgICAwIG5zZWNzDQphY3RpdmUgdGltZXJzOg0KICMwOiA8YzE0YTVhYzg+LCB0aWNr
X3NjaGVkX3RpbWVyLCBTOjAxLCBocnRpbWVyX3N0YXJ0X3JhbmdlX25zLCBzd2FwcGVyLzEvMA0K
ICMgZXhwaXJlcyBhdCA4NzI5MDAwMDAwMC04NzI5MDAwMDAwMCBuc2VjcyBbaW4gNzA1NDc0NCB0
byA3MDU0NzQ0IG5zZWNzXQ0KICMxOiA8ZWQ4ODZkODA+LCB0aW1lcmZkX3RtcnByb2MsIFM6MDEs
IGhydGltZXJfc3RhcnQsIHN5c3RlbWQvMQ0KICMgZXhwaXJlcyBhdCAxMDIyMTMzNjAwNDktMTAy
MjEzMzYwMDQ5IG5zZWNzIFtpbiAxNDkzMDQxNDc5MyB0byAxNDkzMDQxNDc5MyBuc2Vjc10NCiBj
bG9jayAxOg0KICAuYmFzZTogICAgICAgYzE0YTU3NTANCiAgLmluZGV4OiAgICAgIDENCiAgLnJl
c29sdXRpb246IDEgbnNlY3MNCiAgLmdldF90aW1lOiAgIGt0aW1lX2dldF9yZWFsDQogIC5vZmZz
ZXQ6ICAgICAwIG5zZWNzDQphY3RpdmUgdGltZXJzOg0KIGNsb2NrIDI6DQogIC5iYXNlOiAgICAg
ICBjMTRhNTc4OA0KICAuaW5kZXg6ICAgICAgMg0KICAucmVzb2x1dGlvbjogMSBuc2Vjcw0KICAu
Z2V0X3RpbWU6ICAga3RpbWVfZ2V0X2Jvb3R0aW1lDQogIC5vZmZzZXQ6ICAgICAwIG5zZWNzDQph
Y3RpdmUgdGltZXJzOg0KIGNsb2NrIDM6DQogIC5iYXNlOiAgICAgICBjMTRhNTdjMA0KICAuaW5k
ZXg6ICAgICAgMw0KICAucmVzb2x1dGlvbjogMSBuc2Vjcw0KICAuZ2V0X3RpbWU6ICAga3RpbWVf
Z2V0X2Nsb2NrdGFpDQogIC5vZmZzZXQ6ICAgICAwIG5zZWNzDQphY3RpdmUgdGltZXJzOg0KICAu
ZXhwaXJlc19uZXh0ICAgOiA4NzI5MDAwMDAwMCBuc2Vjcw0KICAuaHJlc19hY3RpdmUgICAgOiAx
DQogIC5ucl9ldmVudHMgICAgICA6IDc4Nw0KICAubnJfcmV0cmllcyAgICAgOiAwDQogIC5ucl9o
YW5ncyAgICAgICA6IDANCiAgLm1heF9oYW5nX3RpbWUgIDogMCBuc2Vjcw0KICAubm9oel9tb2Rl
ICAgICAgOiAyDQogIC5sYXN0X3RpY2sgICAgICA6IDg2OTAwMDAwMDAwIG5zZWNzDQogIC50aWNr
X3N0b3BwZWQgICA6IDANCiAgLmlkbGVfamlmZmllcyAgIDogNDI5NDk0NTk4NQ0KICAuaWRsZV9j
YWxscyAgICAgOiAxMjA4DQogIC5pZGxlX3NsZWVwcyAgICA6IDE4MA0KICAuaWRsZV9lbnRyeXRp
bWUgOiA4NzI3NTk0MDkwMSBuc2Vjcw0KICAuaWRsZV93YWtldGltZSAgOiA4NjkwOTM2Nzk2MCBu
c2Vjcw0KICAuaWRsZV9leGl0dGltZSAgOiA4NzI3MzA4MDQ3NiBuc2Vjcw0KICAuaWRsZV9zbGVl
cHRpbWUgOiA4NDg0Nzg0MzQxNyBuc2Vjcw0KICAuaW93YWl0X3NsZWVwdGltZTogMCBuc2Vjcw0K
ICAubGFzdF9qaWZmaWVzICAgOiA0Mjk0OTQ2MDIzDQogIC5uZXh0X2ppZmZpZXMgICA6IDQyOTQ5
NDYwMjQNCiAgLmlkbGVfZXhwaXJlcyAgIDogMTIzMzYwMDAwMDAwIG5zZWNzDQpqaWZmaWVzOiA0
Mjk0OTQ2MDI0DQoNClRpY2sgRGV2aWNlOiBtb2RlOiAgICAgMQ0KQnJvYWRjYXN0IGRldmljZQ0K
Q2xvY2sgRXZlbnQgRGV2aWNlOiBhcm1fZ2xvYmFsX3RpbWVyDQogbWF4X2RlbHRhX25zOiAgIDEy
ODg0OTAyMDA1DQogbWluX2RlbHRhX25zOiAgIDEwMDANCiBtdWx0OiAgICAgICAgICAgNzE1ODI3
ODc2DQogc2hpZnQ6ICAgICAgICAgIDMxDQogbW9kZTogICAgICAgICAgIDMNCiBuZXh0X2V2ZW50
OiAgICAgOTYwODAwMDAwMDAgbnNlY3MNCiBzZXRfbmV4dF9ldmVudDogZ3RfY2xvY2tldmVudF9z
ZXRfbmV4dF9ldmVudA0KIHNldF9tb2RlOiAgICAgICBndF9jbG9ja2V2ZW50X3NldF9tb2RlDQog
ZXZlbnRfaGFuZGxlcjogIHRpY2tfaGFuZGxlX29uZXNob3RfYnJvYWRjYXN0DQogcmV0cmllczog
ICAgICAgIDANCg0KdGlja19icm9hZGNhc3RfbWFzazogMDAwMDAwMDMNCnRpY2tfYnJvYWRjYXN0
X29uZXNob3RfbWFzazogMDAwMDAwMDANCg0KVGljayBEZXZpY2U6IG1vZGU6ICAgICAxDQpQZXIg
Q1BVIGRldmljZTogMA0KQ2xvY2sgRXZlbnQgRGV2aWNlOiBsb2NhbF90aW1lcg0KIG1heF9kZWx0
YV9uczogICAxMjg4NDkwMjAwNQ0KIG1pbl9kZWx0YV9uczogICAxMDAwDQogbXVsdDogICAgICAg
ICAgIDcxNTgyNzg3Ng0KIHNoaWZ0OiAgICAgICAgICAzMQ0KIG1vZGU6ICAgICAgICAgICAzDQog
bmV4dF9ldmVudDogICAgIDg3MjgzNDAxOTM3IG5zZWNzDQogc2V0X25leHRfZXZlbnQ6IHR3ZF9z
ZXRfbmV4dF9ldmVudA0KIHNldF9tb2RlOiAgICAgICB0d2Rfc2V0X21vZGUNCiBldmVudF9oYW5k
bGVyOiAgaHJ0aW1lcl9pbnRlcnJ1cHQNCiByZXRyaWVzOiAgICAgICAgMA0KDQpUaWNrIERldmlj
ZTogbW9kZTogICAgIDENClBlciBDUFUgZGV2aWNlOiAxDQpDbG9jayBFdmVudCBEZXZpY2U6IGxv
Y2FsX3RpbWVyDQogbWF4X2RlbHRhX25zOiAgIDEyODg0OTAyMDA1DQogbWluX2RlbHRhX25zOiAg
IDEwMDANCiBtdWx0OiAgICAgICAgICAgNzE1ODI3ODc2DQogc2hpZnQ6ICAgICAgICAgIDMxDQog
bW9kZTogICAgICAgICAgIDMNCiBuZXh0X2V2ZW50OiAgICAgODcyOTAwMDAwMDAgbnNlY3MNCiBz
ZXRfbmV4dF9ldmVudDogdHdkX3NldF9uZXh0X2V2ZW50DQogc2V0X21vZGU6ICAgICAgIHR3ZF9z
ZXRfbW9kZQ0KIGV2ZW50X2hhbmRsZXI6ICBocnRpbWVyX2ludGVycnVwdA0KIHJldHJpZXM6ICAg
ICAgICAwDQoNCiMgRGVwZW5kZW5jeSBmYWlsZWQuIEFib3J0ZWQgc3RhcnQgb2YgU2VyaWFsIEdl
dHR5IG9uIGdldHR5ICAgICAgICAgICAgICBbG1sxOzMxbSBBQk9SVBtbMG1dDQoK


--LQksG6bCIzRHxTLp--
