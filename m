Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaHSRhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:37:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:21439 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbaHSRhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:37:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="json'?scan'208";a="578874263"
Date: Wed, 20 Aug 2014 01:36:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [mm] f7b5d647946: -3.0% dbench.throughput-MB/sec
Message-ID: <20140819173615.GA8019@localhost>
References: <20140819044134.GB8798@localhost>
 <20140819143428.GC10146@suse.de>
 <20140819154351.GA2697@localhost>
 <20140819161258.GD10146@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140819161258.GD10146@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Aug 19, 2014 at 05:12:58PM +0100, Mel Gorman wrote:
> On Tue, Aug 19, 2014 at 11:43:51PM +0800, Fengguang Wu wrote:
> > On Tue, Aug 19, 2014 at 03:34:28PM +0100, Mel Gorman wrote:
> > > On Tue, Aug 19, 2014 at 12:41:34PM +0800, Fengguang Wu wrote:
> > > > Hi Mel,
> > > > 
> > > > We noticed a minor dbench throughput regression on commit
> > > > f7b5d647946aae1647bf5cd26c16b3a793c1ac49 ("mm: page_alloc: abort fair
> > > > zone allocation policy when remotes nodes are encountered").
> > > > 
> > > > testcase: ivb44/dbench/100%
> > > > 
> > > > bb0b6dffa2ccfbd  f7b5d647946aae1647bf5cd26
> > > > ---------------  -------------------------
> > > >      25692 ± 0%      -3.0%      24913 ± 0%  dbench.throughput-MB/sec
> > > >    6974259 ± 6%     -12.1%    6127616 ± 0%  meminfo.DirectMap2M
> > > >      18.43 ± 0%      -4.6%      17.59 ± 0%  turbostat.RAM_W
> > > >       9302 ± 0%      -3.6%       8965 ± 1%  time.user_time
> > > >    1425791 ± 1%      -2.0%    1396598 ± 0%  time.involuntary_context_switches
> > > > 
> > > > Disclaimer:
> > > > Results have been estimated based on internal Intel analysis and are provided
> > > > for informational purposes only. Any difference in system hardware or software
> > > > design or configuration may affect actual performance.
> > > > 
> > > 
> > > DirectMap2M changing is a major surprise and doesn't make sense for this
> > > machine.
> > 
> > The ivb44's hardware configuration is
> > 
> >         model: Ivytown Ivy Bridge-EP
> >         nr_cpu: 48
> >         memory: 64G
> > 
> > And note that this is an in-memory dbench run, which is why
> > dbench.throughput-MB/sec is so high.
> > 
> > > Did the amount of memory in the machine change between two tests?
> > 
> > Nope. They are back-to-back test runs, so the environment pretty much
> > remains the same.
> 
> Then how did directmap2m change? The sum of the direct maps should
> correspond to the amount of physical memory and this patch has nothing
> to do with any memory initialisation paths that might affect this.
 
Good question. Not sure for the moment, but it looks that even the
multiple boots for the same kernel bb0b6dffa2ccfbd have different
DirectMap2M. And it only happen for kernel bb0b6dffa2ccfbd.
f7b5d64794 remains stable for all boots.

 bb0b6dffa2ccfbd  f7b5d647946aae1647bf5cd26
 ---------------  -------------------------
      %stddev        %change               %stddev
             \          |                 /
    6974259 ± 6%     -12.1%    6127616 ± 0%  meminfo.DirectMap2M

Looking at the concrete numbers for each boot, the DirectMap2M changes
each time.

  "meminfo.DirectMap2M": [
    7182336,
    7190528,
    7178240,
    6131712,
    7188480
  ],

The MemTotal does remain stable for this kernel:

  "meminfo.MemTotal": [
    65869268,
    65869268,
    65869268,
    65869268,
    65869268
  ],

Attached are the full stats for the 2 kernels.

Thanks,
Fengguang

--pWyiEgJYm5f9v55/
Content-Type: application/json
Content-Disposition: attachment; filename="f7b5d6-matrix.json"
Content-Transfer-Encoding: quoted-printable

{=0A  "time.user_time": [=0A    9074.29,=0A    8851.66,=0A    8966.06,=0A  =
  8854.65,=0A    9078.76=0A  ],=0A  "time.system_time": [=0A    23363.05,=
=0A    23461.72,=0A    23529.44,=0A    23473.97,=0A    23398.23=0A  ],=0A  =
"time.percent_of_cpu_this_job_got": [=0A    4503,=0A    4486,=0A    4511,=
=0A    4488,=0A    4508=0A  ],=0A  "time.elapsed_time": [=0A    720.28,=0A =
   720.28,=0A    720.27,=0A    720.25,=0A    720.28=0A  ],=0A  "time.maximu=
m_resident_set_size": [=0A    2832,=0A    2688,=0A    2684,=0A    2768,=0A =
   2832=0A  ],=0A  "time.minor_page_faults": [=0A    2109330,=0A    2483081=
,=0A    1693747,=0A    2498227,=0A    1894154=0A  ],=0A  "time.voluntary_co=
ntext_switches": [=0A    1747435,=0A    2105374,=0A    1319438,=0A    21552=
58,=0A    1539211=0A  ],=0A  "time.involuntary_context_switches": [=0A    1=
402494,=0A    1395599,=0A    1402133,=0A    1385252,=0A    1397514=0A  ],=
=0A  "time.file_system_outputs": [=0A    288,=0A    280,=0A    288,=0A    2=
88,=0A    288=0A  ],=0A  "time.page_size": [=0A    4096,=0A    4096,=0A    =
4096,=0A    4096,=0A    4096=0A  ],=0A  "softirqs.CPU0.HI": [=0A    5,=0A  =
  6,=0A    6,=0A    5,=0A    6=0A  ],=0A  "softirqs.HI": [=0A    5,=0A    6=
,=0A    6,=0A    5,=0A    6=0A  ],=0A  "softirqs.CPU0.TIMER": [=0A    36088=
5,=0A    358398,=0A    359498,=0A    358244,=0A    359204=0A  ],=0A  "softi=
rqs.CPU1.TIMER": [=0A    359958,=0A    357792,=0A    359389,=0A    357698,=
=0A    359440=0A  ],=0A  "softirqs.CPU2.TIMER": [=0A    361043,=0A    35762=
6,=0A    358926,=0A    358067,=0A    359148=0A  ],=0A  "softirqs.CPU3.TIMER=
": [=0A    359700,=0A    358437,=0A    359279,=0A    358044,=0A    358815=
=0A  ],=0A  "softirqs.CPU4.TIMER": [=0A    360108,=0A    357833,=0A    3587=
54,=0A    357836,=0A    358708=0A  ],=0A  "softirqs.CPU5.TIMER": [=0A    35=
9642,=0A    356929,=0A    358393,=0A    357547,=0A    358772=0A  ],=0A  "so=
ftirqs.CPU6.TIMER": [=0A    359361,=0A    356837,=0A    358588,=0A    35727=
6,=0A    358224=0A  ],=0A  "softirqs.CPU7.TIMER": [=0A    360143,=0A    356=
796,=0A    358368,=0A    357737,=0A    358841=0A  ],=0A  "softirqs.CPU8.TIM=
ER": [=0A    359762,=0A    356814,=0A    358352,=0A    357188,=0A    358181=
=0A  ],=0A  "softirqs.CPU9.TIMER": [=0A    359612,=0A    356607,=0A    3591=
10,=0A    357334,=0A    358410=0A  ],=0A  "softirqs.CPU10.TIMER": [=0A    3=
59437,=0A    356873,=0A    358455,=0A    356912,=0A    358182=0A  ],=0A  "s=
oftirqs.CPU11.TIMER": [=0A    359774,=0A    356155,=0A    358871,=0A    356=
685,=0A    358262=0A  ],=0A  "softirqs.CPU12.TIMER": [=0A    356033,=0A    =
352012,=0A    354387,=0A    355087,=0A    353798=0A  ],=0A  "softirqs.CPU13=
=2ETIMER": [=0A    356027,=0A    353712,=0A    354021,=0A    352165,=0A    =
354933=0A  ],=0A  "softirqs.CPU14.TIMER": [=0A    356652,=0A    354367,=0A =
   357791,=0A    354594,=0A    356338=0A  ],=0A  "softirqs.CPU15.TIMER": [=
=0A    356672,=0A    352507,=0A    356977,=0A    352516,=0A    354593=0A  ]=
,=0A  "softirqs.CPU16.TIMER": [=0A    354349,=0A    351139,=0A    354229,=
=0A    351998,=0A    355718=0A  ],=0A  "softirqs.CPU17.TIMER": [=0A    3554=
67,=0A    349633,=0A    354307,=0A    350726,=0A    355164=0A  ],=0A  "soft=
irqs.CPU18.TIMER": [=0A    354845,=0A    350576,=0A    354607,=0A    351396=
,=0A    354027=0A  ],=0A  "softirqs.CPU19.TIMER": [=0A    355176,=0A    350=
768,=0A    353731,=0A    349999,=0A    352060=0A  ],=0A  "softirqs.CPU20.TI=
MER": [=0A    354004,=0A    353657,=0A    353513,=0A    352750,=0A    35310=
7=0A  ],=0A  "softirqs.CPU21.TIMER": [=0A    350906,=0A    350138,=0A    35=
3453,=0A    350874,=0A    352638=0A  ],=0A  "softirqs.CPU22.TIMER": [=0A   =
 354756,=0A    350960,=0A    352375,=0A    351805,=0A    353161=0A  ],=0A  =
"softirqs.CPU23.TIMER": [=0A    352993,=0A    350221,=0A    352466,=0A    3=
51500,=0A    352764=0A  ],=0A  "softirqs.CPU24.TIMER": [=0A    360931,=0A  =
  356106,=0A    357930,=0A    356337,=0A    357960=0A  ],=0A  "softirqs.CPU=
25.TIMER": [=0A    359901,=0A    356770,=0A    358269,=0A    357609,=0A    =
358478=0A  ],=0A  "softirqs.CPU26.TIMER": [=0A    359351,=0A    355825,=0A =
   357964,=0A    356813,=0A    357954=0A  ],=0A  "softirqs.CPU27.TIMER": [=
=0A    359471,=0A    355404,=0A    357763,=0A    356178,=0A    357399=0A  ]=
,=0A  "softirqs.CPU28.TIMER": [=0A    358875,=0A    355755,=0A    357748,=
=0A    356224,=0A    357556=0A  ],=0A  "softirqs.CPU29.TIMER": [=0A    3590=
72,=0A    355773,=0A    357763,=0A    356390,=0A    357541=0A  ],=0A  "soft=
irqs.CPU30.TIMER": [=0A    359057,=0A    356239,=0A    357940,=0A    356115=
,=0A    357554=0A  ],=0A  "softirqs.CPU31.TIMER": [=0A    358251,=0A    356=
369,=0A    358035,=0A    356477,=0A    357556=0A  ],=0A  "softirqs.CPU32.TI=
MER": [=0A    358902,=0A    355897,=0A    357316,=0A    355980,=0A    35768=
1=0A  ],=0A  "softirqs.CPU33.TIMER": [=0A    358661,=0A    356182,=0A    35=
7159,=0A    355264,=0A    357239=0A  ],=0A  "softirqs.CPU34.TIMER": [=0A   =
 358590,=0A    355142,=0A    357573,=0A    355431,=0A    356848=0A  ],=0A  =
"softirqs.CPU35.TIMER": [=0A    358305,=0A    355720,=0A    357198,=0A    3=
55237,=0A    357219=0A  ],=0A  "softirqs.CPU36.TIMER": [=0A    354520,=0A  =
  349945,=0A    353810,=0A    348478,=0A    351562=0A  ],=0A  "softirqs.CPU=
37.TIMER": [=0A    352964,=0A    350919,=0A    354168,=0A    349737,=0A    =
353220=0A  ],=0A  "softirqs.CPU38.TIMER": [=0A    353539,=0A    350299,=0A =
   353882,=0A    349145,=0A    352139=0A  ],=0A  "softirqs.CPU39.TIMER": [=
=0A    352900,=0A    349355,=0A    351886,=0A    348207,=0A    352584=0A  ]=
,=0A  "softirqs.CPU40.TIMER": [=0A    353896,=0A    348293,=0A    352242,=
=0A    349994,=0A    351453=0A  ],=0A  "softirqs.CPU41.TIMER": [=0A    3530=
94,=0A    349587,=0A    352580,=0A    349423,=0A    350933=0A  ],=0A  "soft=
irqs.CPU42.TIMER": [=0A    352327,=0A    347849,=0A    352172,=0A    348818=
,=0A    351226=0A  ],=0A  "softirqs.CPU43.TIMER": [=0A    351762,=0A    349=
883,=0A    352735,=0A    347762,=0A    350822=0A  ],=0A  "softirqs.CPU44.TI=
MER": [=0A    353844,=0A    347213,=0A    352025,=0A    348665,=0A    35030=
7=0A  ],=0A  "softirqs.CPU45.TIMER": [=0A    352947,=0A    349276,=0A    35=
2168,=0A    348265,=0A    349760=0A  ],=0A  "softirqs.CPU46.TIMER": [=0A   =
 352357,=0A    348710,=0A    351984,=0A    348427,=0A    351143=0A  ],=0A  =
"softirqs.CPU47.TIMER": [=0A    351887,=0A    347977,=0A    351539,=0A    3=
47716,=0A    350093=0A  ],=0A  "softirqs.TIMER": [=0A    17122721,=0A    16=
967286,=0A    17081703,=0A    16974683,=0A    17058728=0A  ],=0A  "softirqs=
=2ECPU0.NET_TX": [=0A    97,=0A    96,=0A    93,=0A    93,=0A    97=0A  ],=
=0A  "softirqs.CPU21.NET_TX": [=0A    1=0A  ],=0A  "softirqs.CPU37.NET_TX":=
 [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "softirqs.NET_TX"=
: [=0A    99,=0A    98,=0A    95,=0A    95,=0A    99=0A  ],=0A  "softirqs.C=
PU0.NET_RX": [=0A    2320,=0A    2149,=0A    2217,=0A    2322,=0A    2090=
=0A  ],=0A  "softirqs.NET_RX": [=0A    2320,=0A    2149,=0A    2217,=0A    =
2322,=0A    2090=0A  ],=0A  "softirqs.CPU0.TASKLET": [=0A    218,=0A    216=
,=0A    223,=0A    217,=0A    220=0A  ],=0A  "softirqs.CPU12.TASKLET": [=0A=
    1,=0A    1,=0A    0,=0A    2,=0A    1=0A  ],=0A  "softirqs.CPU13.TASKLE=
T": [=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "softirqs.CPU14.TASKLET=
": [=0A    4,=0A    4,=0A    2,=0A    2,=0A    3=0A  ],=0A  "softirqs.CPU15=
=2ETASKLET": [=0A    3,=0A    1,=0A    1,=0A    3,=0A    3=0A  ],=0A  "soft=
irqs.CPU16.TASKLET": [=0A    3,=0A    4,=0A    1,=0A    3,=0A    3=0A  ],=
=0A  "softirqs.CPU17.TASKLET": [=0A    3,=0A    1,=0A    0,=0A    2,=0A    =
2=0A  ],=0A  "softirqs.CPU18.TASKLET": [=0A    1,=0A    1,=0A    0,=0A    0=
,=0A    3=0A  ],=0A  "softirqs.CPU20.TASKLET": [=0A    1,=0A    1,=0A    0,=
=0A    1,=0A    1=0A  ],=0A  "softirqs.CPU21.TASKLET": [=0A    1,=0A    3,=
=0A    0,=0A    2,=0A    1=0A  ],=0A  "softirqs.CPU22.TASKLET": [=0A    1,=
=0A    2,=0A    0,=0A    0,=0A    1=0A  ],=0A  "softirqs.CPU23.TASKLET": [=
=0A    1,=0A    1,=0A    0,=0A    2,=0A    1=0A  ],=0A  "softirqs.CPU25.TAS=
KLET": [=0A    360,=0A    360,=0A    361,=0A    1=0A  ],=0A  "softirqs.CPU3=
7.TASKLET": [=0A    3,=0A    3,=0A    1,=0A    363,=0A    361=0A  ],=0A  "s=
oftirqs.CPU46.TASKLET": [=0A    1=0A  ],=0A  "softirqs.TASKLET": [=0A    60=
2,=0A    603,=0A    606,=0A    601,=0A    604=0A  ],=0A  "softirqs.CPU0.SCH=
ED": [=0A    9505,=0A    9783,=0A    7439,=0A    10191,=0A    8473=0A  ],=
=0A  "softirqs.CPU1.SCHED": [=0A    8139,=0A    8520,=0A    6831,=0A    903=
0,=0A    7553=0A  ],=0A  "softirqs.CPU2.SCHED": [=0A    8432,=0A    8403,=
=0A    6288,=0A    8899,=0A    7340=0A  ],=0A  "softirqs.CPU3.SCHED": [=0A =
   8017,=0A    8765,=0A    6218,=0A    8799,=0A    7197=0A  ],=0A  "softirq=
s.CPU4.SCHED": [=0A    7790,=0A    8375,=0A    6246,=0A    8665,=0A    7307=
=0A  ],=0A  "softirqs.CPU5.SCHED": [=0A    8141,=0A    8118,=0A    6222,=0A=
    8609,=0A    7195=0A  ],=0A  "softirqs.CPU6.SCHED": [=0A    7925,=0A    =
8016,=0A    6208,=0A    8679,=0A    7130=0A  ],=0A  "softirqs.CPU7.SCHED": =
[=0A    7870,=0A    8102,=0A    6254,=0A    8903,=0A    7055=0A  ],=0A  "so=
ftirqs.CPU8.SCHED": [=0A    7820,=0A    8119,=0A    6232,=0A    8603,=0A   =
 7154=0A  ],=0A  "softirqs.CPU9.SCHED": [=0A    7759,=0A    8089,=0A    631=
0,=0A    8645,=0A    7059=0A  ],=0A  "softirqs.CPU10.SCHED": [=0A    7756,=
=0A    8077,=0A    6179,=0A    8680,=0A    7178=0A  ],=0A  "softirqs.CPU11.=
SCHED": [=0A    7755,=0A    8165,=0A    6109,=0A    8669,=0A    6964=0A  ],=
=0A  "softirqs.CPU12.SCHED": [=0A    9818,=0A    10257,=0A    7743,=0A    1=
0043,=0A    8269=0A  ],=0A  "softirqs.CPU13.SCHED": [=0A    9364,=0A    104=
05,=0A    7914,=0A    9366,=0A    7850=0A  ],=0A  "softirqs.CPU14.SCHED": [=
=0A    9314,=0A    9716,=0A    7641,=0A    9541,=0A    8170=0A  ],=0A  "sof=
tirqs.CPU15.SCHED": [=0A    9916,=0A    9744,=0A    8802,=0A    9339,=0A   =
 8230=0A  ],=0A  "softirqs.CPU16.SCHED": [=0A    9629,=0A    9714,=0A    76=
77,=0A    9496,=0A    8849=0A  ],=0A  "softirqs.CPU17.SCHED": [=0A    9379,=
=0A    10057,=0A    7652,=0A    9498,=0A    8210=0A  ],=0A  "softirqs.CPU18=
=2ESCHED": [=0A    9343,=0A    9777,=0A    7768,=0A    9224,=0A    8070=0A =
 ],=0A  "softirqs.CPU19.SCHED": [=0A    9398,=0A    9681,=0A    7773,=0A   =
 9576,=0A    8531=0A  ],=0A  "softirqs.CPU20.SCHED": [=0A    9479,=0A    10=
100,=0A    7796,=0A    9354,=0A    8248=0A  ],=0A  "softirqs.CPU21.SCHED": =
[=0A    9176,=0A    9701,=0A    7731,=0A    9394,=0A    8271=0A  ],=0A  "so=
ftirqs.CPU22.SCHED": [=0A    9469,=0A    9709,=0A    7700,=0A    9205,=0A  =
  8032=0A  ],=0A  "softirqs.CPU23.SCHED": [=0A    9606,=0A    9601,=0A    7=
884,=0A    9376,=0A    8016=0A  ],=0A  "softirqs.CPU24.SCHED": [=0A    7567=
,=0A    7931,=0A    6086,=0A    8495,=0A    6988=0A  ],=0A  "softirqs.CPU25=
=2ESCHED": [=0A    8008,=0A    8424,=0A    6694,=0A    9182,=0A    7633=0A =
 ],=0A  "softirqs.CPU26.SCHED": [=0A    7828,=0A    8059,=0A    6333,=0A   =
 8703,=0A    7065=0A  ],=0A  "softirqs.CPU27.SCHED": [=0A    7755,=0A    79=
78,=0A    6205,=0A    8637,=0A    7092=0A  ],=0A  "softirqs.CPU28.SCHED": [=
=0A    7688,=0A    7972,=0A    6050,=0A    8643,=0A    6961=0A  ],=0A  "sof=
tirqs.CPU29.SCHED": [=0A    7610,=0A    7907,=0A    6144,=0A    8546,=0A   =
 7058=0A  ],=0A  "softirqs.CPU30.SCHED": [=0A    7623,=0A    7870,=0A    60=
91,=0A    8539,=0A    6911=0A  ],=0A  "softirqs.CPU31.SCHED": [=0A    7698,=
=0A    8009,=0A    6107,=0A    8582,=0A    6892=0A  ],=0A  "softirqs.CPU32.=
SCHED": [=0A    7703,=0A    8054,=0A    6237,=0A    8565,=0A    6938=0A  ],=
=0A  "softirqs.CPU33.SCHED": [=0A    7874,=0A    7989,=0A    6177,=0A    85=
11,=0A    6988=0A  ],=0A  "softirqs.CPU34.SCHED": [=0A    7632,=0A    7882,=
=0A    6106,=0A    8506,=0A    7057=0A  ],=0A  "softirqs.CPU35.SCHED": [=0A=
    7494,=0A    7992,=0A    6030,=0A    8588,=0A    7015=0A  ],=0A  "softir=
qs.CPU36.SCHED": [=0A    8846,=0A    9397,=0A    7542,=0A    9399,=0A    82=
24=0A  ],=0A  "softirqs.CPU37.SCHED": [=0A    10052,=0A    9913,=0A    7932=
,=0A    9827,=0A    8633=0A  ],=0A  "softirqs.CPU38.SCHED": [=0A    9305,=
=0A    9684,=0A    7402,=0A    9156,=0A    7929=0A  ],=0A  "softirqs.CPU39.=
SCHED": [=0A    9289,=0A    9835,=0A    7744,=0A    9355,=0A    8224=0A  ],=
=0A  "softirqs.CPU40.SCHED": [=0A    9034,=0A    9423,=0A    7572,=0A    89=
55,=0A    7975=0A  ],=0A  "softirqs.CPU41.SCHED": [=0A    9294,=0A    9299,=
=0A    7374,=0A    9245,=0A    8104=0A  ],=0A  "softirqs.CPU42.SCHED": [=0A=
    9507,=0A    9663,=0A    7351,=0A    9280,=0A    7856=0A  ],=0A  "softir=
qs.CPU43.SCHED": [=0A    9434,=0A    9214,=0A    7288,=0A    9270,=0A    82=
21=0A  ],=0A  "softirqs.CPU44.SCHED": [=0A    9072,=0A    9682,=0A    7578,=
=0A    9114,=0A    8065=0A  ],=0A  "softirqs.CPU45.SCHED": [=0A    8997,=0A=
    9326,=0A    7652,=0A    9306,=0A    8191=0A  ],=0A  "softirqs.CPU46.SCH=
ED": [=0A    9226,=0A    9152,=0A    7436,=0A    8977,=0A    7911=0A  ],=0A=
  "softirqs.CPU47.SCHED": [=0A    9147,=0A    9346,=0A    7272,=0A    9364,=
=0A    8143=0A  ],=0A  "softirqs.SCHED": [=0A    414492,=0A    429007,=0A  =
  335031,=0A    434542,=0A    368436=0A  ],=0A  "softirqs.CPU0.HRTIMER": [=
=0A    14,=0A    15,=0A    7,=0A    17,=0A    16=0A  ],=0A  "softirqs.CPU1.=
HRTIMER": [=0A    7,=0A    13,=0A    10,=0A    11,=0A    5=0A  ],=0A  "soft=
irqs.CPU2.HRTIMER": [=0A    16,=0A    7,=0A    9,=0A    16,=0A    13=0A  ],=
=0A  "softirqs.CPU3.HRTIMER": [=0A    9,=0A    13,=0A    10,=0A    9,=0A   =
 12=0A  ],=0A  "softirqs.CPU4.HRTIMER": [=0A    11,=0A    13,=0A    7,=0A  =
  13,=0A    7=0A  ],=0A  "softirqs.CPU5.HRTIMER": [=0A    10,=0A    14,=0A =
   5,=0A    12,=0A    7=0A  ],=0A  "softirqs.CPU6.HRTIMER": [=0A    14,=0A =
   10,=0A    7,=0A    14,=0A    10=0A  ],=0A  "softirqs.CPU7.HRTIMER": [=0A=
    11,=0A    11,=0A    11,=0A    20,=0A    12=0A  ],=0A  "softirqs.CPU8.HR=
TIMER": [=0A    9,=0A    13,=0A    11,=0A    11,=0A    10=0A  ],=0A  "softi=
rqs.CPU9.HRTIMER": [=0A    6,=0A    16,=0A    12,=0A    10,=0A    9=0A  ],=
=0A  "softirqs.CPU10.HRTIMER": [=0A    9,=0A    10,=0A    8,=0A    13,=0A  =
  9=0A  ],=0A  "softirqs.CPU11.HRTIMER": [=0A    9,=0A    13,=0A    9,=0A  =
  12,=0A    7=0A  ],=0A  "softirqs.CPU12.HRTIMER": [=0A    9,=0A    6,=0A  =
  8,=0A    15,=0A    9=0A  ],=0A  "softirqs.CPU13.HRTIMER": [=0A    9,=0A  =
  12,=0A    6,=0A    14,=0A    11=0A  ],=0A  "softirqs.CPU14.HRTIMER": [=0A=
    15,=0A    12,=0A    9,=0A    20,=0A    15=0A  ],=0A  "softirqs.CPU15.HR=
TIMER": [=0A    6,=0A    24,=0A    12,=0A    13,=0A    19=0A  ],=0A  "softi=
rqs.CPU16.HRTIMER": [=0A    15,=0A    13,=0A    9,=0A    13,=0A    6=0A  ],=
=0A  "softirqs.CPU17.HRTIMER": [=0A    10,=0A    14,=0A    7,=0A    17,=0A =
   10=0A  ],=0A  "softirqs.CPU18.HRTIMER": [=0A    9,=0A    12,=0A    6,=0A=
    12,=0A    14=0A  ],=0A  "softirqs.CPU19.HRTIMER": [=0A    10,=0A    9,=
=0A    6,=0A    12,=0A    8=0A  ],=0A  "softirqs.CPU20.HRTIMER": [=0A    12=
,=0A    9,=0A    7,=0A    16,=0A    8=0A  ],=0A  "softirqs.CPU21.HRTIMER": =
[=0A    12,=0A    9,=0A    8,=0A    13,=0A    12=0A  ],=0A  "softirqs.CPU22=
=2EHRTIMER": [=0A    10,=0A    11,=0A    8,=0A    12,=0A    8=0A  ],=0A  "s=
oftirqs.CPU23.HRTIMER": [=0A    7,=0A    12,=0A    7,=0A    9,=0A    8=0A  =
],=0A  "softirqs.CPU24.HRTIMER": [=0A    10,=0A    12,=0A    7,=0A    11,=
=0A    7=0A  ],=0A  "softirqs.CPU25.HRTIMER": [=0A    14,=0A    18,=0A    8=
,=0A    14,=0A    8=0A  ],=0A  "softirqs.CPU26.HRTIMER": [=0A    6,=0A    1=
0,=0A    5,=0A    12,=0A    13=0A  ],=0A  "softirqs.CPU27.HRTIMER": [=0A   =
 11,=0A    13,=0A    7,=0A    13,=0A    9=0A  ],=0A  "softirqs.CPU28.HRTIME=
R": [=0A    11,=0A    15,=0A    7,=0A    10,=0A    7=0A  ],=0A  "softirqs.C=
PU29.HRTIMER": [=0A    8,=0A    9,=0A    7,=0A    12,=0A    11=0A  ],=0A  "=
softirqs.CPU30.HRTIMER": [=0A    7,=0A    9,=0A    6,=0A    13,=0A    9=0A =
 ],=0A  "softirqs.CPU31.HRTIMER": [=0A    15,=0A    10,=0A    8,=0A    14,=
=0A    9=0A  ],=0A  "softirqs.CPU32.HRTIMER": [=0A    14,=0A    8,=0A    5,=
=0A    10,=0A    11=0A  ],=0A  "softirqs.CPU33.HRTIMER": [=0A    5,=0A    1=
3,=0A    7,=0A    17,=0A    10=0A  ],=0A  "softirqs.CPU34.HRTIMER": [=0A   =
 13,=0A    12,=0A    5,=0A    11,=0A    8=0A  ],=0A  "softirqs.CPU35.HRTIME=
R": [=0A    10,=0A    12,=0A    9,=0A    9,=0A    10=0A  ],=0A  "softirqs.C=
PU36.HRTIMER": [=0A    11,=0A    12,=0A    7,=0A    10,=0A    10=0A  ],=0A =
 "softirqs.CPU37.HRTIMER": [=0A    10,=0A    14,=0A    9,=0A    13,=0A    1=
4=0A  ],=0A  "softirqs.CPU38.HRTIMER": [=0A    17,=0A    18,=0A    10,=0A  =
  14,=0A    15=0A  ],=0A  "softirqs.CPU39.HRTIMER": [=0A    7,=0A    10,=0A=
    6,=0A    11,=0A    15=0A  ],=0A  "softirqs.CPU40.HRTIMER": [=0A    11,=
=0A    16,=0A    9,=0A    12,=0A    12=0A  ],=0A  "softirqs.CPU41.HRTIMER":=
 [=0A    6,=0A    16,=0A    5,=0A    12,=0A    12=0A  ],=0A  "softirqs.CPU4=
2.HRTIMER": [=0A    9,=0A    15,=0A    8,=0A    17,=0A    14=0A  ],=0A  "so=
ftirqs.CPU43.HRTIMER": [=0A    8,=0A    17,=0A    7,=0A    15,=0A    12=0A =
 ],=0A  "softirqs.CPU44.HRTIMER": [=0A    13,=0A    11,=0A    9,=0A    17,=
=0A    6=0A  ],=0A  "softirqs.CPU45.HRTIMER": [=0A    15,=0A    12,=0A    6=
,=0A    10,=0A    13=0A  ],=0A  "softirqs.CPU46.HRTIMER": [=0A    8,=0A    =
12,=0A    8,=0A    10,=0A    9=0A  ],=0A  "softirqs.CPU47.HRTIMER": [=0A   =
 14,=0A    18,=0A    7,=0A    13,=0A    8=0A  ],=0A  "softirqs.HRTIMER": [=
=0A    511,=0A    614,=0A    384,=0A    635,=0A    510=0A  ],=0A  "softirqs=
=2ECPU0.RCU": [=0A    61992,=0A    59796,=0A    58514,=0A    59706,=0A    6=
0600=0A  ],=0A  "softirqs.CPU1.RCU": [=0A    62979,=0A    60970,=0A    6077=
3,=0A    60744,=0A    62443=0A  ],=0A  "softirqs.CPU2.RCU": [=0A    64288,=
=0A    61843,=0A    61837,=0A    61455,=0A    63467=0A  ],=0A  "softirqs.CP=
U3.RCU": [=0A    63615,=0A    61472,=0A    61785,=0A    61814,=0A    63705=
=0A  ],=0A  "softirqs.CPU4.RCU": [=0A    63068,=0A    60740,=0A    60940,=
=0A    61501,=0A    62999=0A  ],=0A  "softirqs.CPU5.RCU": [=0A    62627,=0A=
    61935,=0A    60291,=0A    61265,=0A    63485=0A  ],=0A  "softirqs.CPU6.=
RCU": [=0A    62374,=0A    61058,=0A    60521,=0A    61740,=0A    62775=0A =
 ],=0A  "softirqs.CPU7.RCU": [=0A    62469,=0A    61310,=0A    60245,=0A   =
 62381,=0A    62845=0A  ],=0A  "softirqs.CPU8.RCU": [=0A    62175,=0A    60=
097,=0A    59380,=0A    60164,=0A    61530=0A  ],=0A  "softirqs.CPU9.RCU": =
[=0A    64754,=0A    60110,=0A    59846,=0A    60058,=0A    60959=0A  ],=0A=
  "softirqs.CPU10.RCU": [=0A    62245,=0A    60444,=0A    59830,=0A    6008=
7,=0A    60708=0A  ],=0A  "softirqs.CPU11.RCU": [=0A    61470,=0A    59953,=
=0A    60166,=0A    59684,=0A    60164=0A  ],=0A  "softirqs.CPU12.RCU": [=
=0A    57717,=0A    56251,=0A    56319,=0A    56583,=0A    57393=0A  ],=0A =
 "softirqs.CPU13.RCU": [=0A    58072,=0A    56452,=0A    56183,=0A    56189=
,=0A    57950=0A  ],=0A  "softirqs.CPU14.RCU": [=0A    58043,=0A    57831,=
=0A    57426,=0A    57631,=0A    58607=0A  ],=0A  "softirqs.CPU15.RCU": [=
=0A    57977,=0A    56457,=0A    56818,=0A    56746,=0A    57346=0A  ],=0A =
 "softirqs.CPU16.RCU": [=0A    60235,=0A    59389,=0A    58998,=0A    59160=
,=0A    60629=0A  ],=0A  "softirqs.CPU17.RCU": [=0A    60021,=0A    59398,=
=0A    59073,=0A    59201,=0A    60763=0A  ],=0A  "softirqs.CPU18.RCU": [=
=0A    60044,=0A    58702,=0A    58871,=0A    59209,=0A    61115=0A  ],=0A =
 "softirqs.CPU19.RCU": [=0A    59580,=0A    59189,=0A    59107,=0A    58944=
,=0A    60736=0A  ],=0A  "softirqs.CPU20.RCU": [=0A    59914,=0A    59042,=
=0A    59166,=0A    59333,=0A    60209=0A  ],=0A  "softirqs.CPU21.RCU": [=
=0A    59993,=0A    59403,=0A    59121,=0A    59459,=0A    59975=0A  ],=0A =
 "softirqs.CPU22.RCU": [=0A    60248,=0A    59336,=0A    59166,=0A    59396=
,=0A    59284=0A  ],=0A  "softirqs.CPU23.RCU": [=0A    59595,=0A    59429,=
=0A    59228,=0A    57794,=0A    59467=0A  ],=0A  "softirqs.CPU24.RCU": [=
=0A    63066,=0A    60843,=0A    59791,=0A    60802,=0A    61847=0A  ],=0A =
 "softirqs.CPU25.RCU": [=0A    62850,=0A    61549,=0A    60985,=0A    61446=
,=0A    62048=0A  ],=0A  "softirqs.CPU26.RCU": [=0A    62541,=0A    61005,=
=0A    60816,=0A    60873,=0A    61885=0A  ],=0A  "softirqs.CPU27.RCU": [=
=0A    62731,=0A    59875,=0A    61355,=0A    61170,=0A    62015=0A  ],=0A =
 "softirqs.CPU28.RCU": [=0A    61463,=0A    59704,=0A    60490,=0A    60768=
,=0A    61643=0A  ],=0A  "softirqs.CPU29.RCU": [=0A    63992,=0A    60390,=
=0A    59646,=0A    60924,=0A    61182=0A  ],=0A  "softirqs.CPU30.RCU": [=
=0A    61628,=0A    60365,=0A    59615,=0A    60689,=0A    62035=0A  ],=0A =
 "softirqs.CPU31.RCU": [=0A    61717,=0A    60516,=0A    59372,=0A    61007=
,=0A    62133=0A  ],=0A  "softirqs.CPU32.RCU": [=0A    59506,=0A    58263,=
=0A    57180,=0A    57860,=0A    58756=0A  ],=0A  "softirqs.CPU33.RCU": [=
=0A    59711,=0A    58268,=0A    57440,=0A    58335,=0A    58546=0A  ],=0A =
 "softirqs.CPU34.RCU": [=0A    59529,=0A    57840,=0A    58493,=0A    57963=
,=0A    58488=0A  ],=0A  "softirqs.CPU35.RCU": [=0A    60123,=0A    58258,=
=0A    58287,=0A    57909,=0A    58882=0A  ],=0A  "softirqs.CPU36.RCU": [=
=0A    60391,=0A    58652,=0A    58368,=0A    58167,=0A    59303=0A  ],=0A =
 "softirqs.CPU37.RCU": [=0A    60104,=0A    59227,=0A    59337,=0A    58444=
,=0A    60159=0A  ],=0A  "softirqs.CPU38.RCU": [=0A    60895,=0A    59317,=
=0A    59994,=0A    59322,=0A    60117=0A  ],=0A  "softirqs.CPU39.RCU": [=
=0A    61091,=0A    58906,=0A    60125,=0A    60178,=0A    61226=0A  ],=0A =
 "softirqs.CPU40.RCU": [=0A    61198,=0A    59806,=0A    59653,=0A    60193=
,=0A    60979=0A  ],=0A  "softirqs.CPU41.RCU": [=0A    60902,=0A    60266,=
=0A    59868,=0A    60157,=0A    60681=0A  ],=0A  "softirqs.CPU42.RCU": [=
=0A    60843,=0A    59990,=0A    59681,=0A    60036,=0A    61222=0A  ],=0A =
 "softirqs.CPU43.RCU": [=0A    60044,=0A    60148,=0A    59433,=0A    60036=
,=0A    60549=0A  ],=0A  "softirqs.CPU44.RCU": [=0A    60283,=0A    58936,=
=0A    58251,=0A    58845,=0A    59506=0A  ],=0A  "softirqs.CPU45.RCU": [=
=0A    60054,=0A    59092,=0A    58754,=0A    58579,=0A    59570=0A  ],=0A =
 "softirqs.CPU46.RCU": [=0A    60007,=0A    59323,=0A    58913,=0A    58323=
,=0A    59466=0A  ],=0A  "softirqs.CPU47.RCU": [=0A    59617,=0A    58992,=
=0A    58802,=0A    58069,=0A    59231=0A  ],=0A  "softirqs.RCU": [=0A    2=
929793,=0A    2860148,=0A    2848265,=0A    2860354,=0A    2910636=0A  ],=
=0A  "uptime.boot": [=0A    745.65,=0A    745.74,=0A    744.06,=0A    743.9=
7,=0A    743.66=0A  ],=0A  "uptime.idle": [=0A    1691.5,=0A    1791.36,=0A=
    1542.18,=0A    1670.12,=0A    1549.75=0A  ],=0A  "perf-profile.cpu-cycl=
es.copy_user_enhanced_fast_string.copy_page_to_iter.generic_file_read_iter.=
new_sync_read.vfs_read": [=0A    15.88,=0A    15.8,=0A    16.0,=0A    15.79=
,=0A    16.11=0A  ],=0A  "perf-profile.cpu-cycles.copy_user_enhanced_fast_s=
tring.iov_iter_copy_from_user_atomic.generic_perform_write.__generic_file_w=
rite_iter.generic_file_write_iter": [=0A    8.97,=0A    9.01,=0A    8.88,=
=0A    8.82,=0A    9.02=0A  ],=0A  "perf-profile.cpu-cycles.rcu_nocb_kthrea=
d.kthread.ret_from_fork": [=0A    2.33,=0A    2.35,=0A    2.42,=0A    2.29,=
=0A    2.32=0A  ],=0A  "perf-profile.cpu-cycles.find_get_entry.pagecache_ge=
t_page.generic_file_read_iter.new_sync_read.vfs_read": [=0A    2.17,=0A    =
2.15,=0A    2.13,=0A    2.12,=0A    2.12=0A  ],=0A  "perf-profile.cpu-cycle=
s.__vdso_gettimeofday": [=0A    1.9,=0A    1.97,=0A    1.96,=0A    2.14,=0A=
    1.96=0A  ],=0A  "perf-profile.cpu-cycles.avc_has_perm_noaudit.selinux_i=
node_permission.security_inode_permission.__inode_permission.inode_permissi=
on": [=0A    1.42,=0A    1.75,=0A    1.4,=0A    1.56,=0A    1.38=0A  ],=0A =
 "perf-profile.cpu-cycles.get_empty_filp.path_openat.do_filp_open.do_sys_op=
en.sys_openat": [=0A    1.28,=0A    1.26,=0A    1.28,=0A    1.29,=0A    1.3=
1=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_permission.security_ino=
de_permission.__inode_permission.inode_permission.link_path_walk": [=0A    =
1.12,=0A    0.98,=0A    1.1,=0A    1.03,=0A    1.05=0A  ],=0A  "perf-profil=
e.cpu-cycles._raw_spin_lock.dcache_readdir.iterate_dir.sys_getdents.system_=
call_fastpath": [=0A    1.08,=0A    1.09,=0A    1.09,=0A    1.08,=0A    1.0=
7=0A  ],=0A  "perf-profile.cpu-cycles.set_page_dirty.simple_write_end.gener=
ic_perform_write.__generic_file_write_iter.generic_file_write_iter": [=0A  =
  0.91,=0A    0.94,=0A    0.91,=0A    0.91,=0A    0.93=0A  ],=0A  "perf-pro=
file.cpu-cycles.link_path_walk.path_lookupat.filename_lookup.user_path_at_e=
mpty.user_path_at": [=0A    0.88,=0A    0.88,=0A    0.91,=0A    0.89,=0A   =
 0.92=0A  ],=0A  "perf-profile.cpu-cycles.simple_write_end.generic_perform_=
write.__generic_file_write_iter.generic_file_write_iter.new_sync_write": [=
=0A    0.84,=0A    0.85,=0A    0.87,=0A    0.84,=0A    0.88=0A  ],=0A  "per=
f-profile.cpu-cycles.get_empty_filp.path_openat.do_filp_open.do_sys_open.sy=
s_open": [=0A    0.82,=0A    0.82,=0A    0.82,=0A    0.82,=0A    0.84=0A  ]=
,=0A  "perf-profile.cpu-cycles.find_get_entry.pagecache_get_page.grab_cache=
_page_write_begin.simple_write_begin.generic_perform_write": [=0A    0.82,=
=0A    0.82,=0A    0.83,=0A    0.8,=0A    0.81=0A  ],=0A  "perf-profile.cpu=
-cycles.close": [=0A    0.79,=0A    0.77,=0A    0.79,=0A    0.77,=0A    0.7=
8=0A  ],=0A  "perf-profile.cpu-cycles.file_free_rcu.rcu_nocb_kthread.kthrea=
d.ret_from_fork": [=0A    0.77,=0A    0.76,=0A    0.78,=0A    0.75,=0A    0=
=2E73=0A  ],=0A  "perf-profile.cpu-cycles.__mem_cgroup_uncharge_common.mem_=
cgroup_uncharge_cache_page.delete_from_page_cache.truncate_inode_page.trunc=
ate_inode_pages_range": [=0A    0.74,=0A    0.72,=0A    0.72,=0A    0.72,=
=0A    0.74=0A  ],=0A  "perf-profile.cpu-cycles.__d_lookup_rcu.lookup_fast.=
link_path_walk.path_lookupat.filename_lookup": [=0A    0.68,=0A    0.72,=0A=
    0.68,=0A    0.68,=0A    0.67=0A  ],=0A  "perf-profile.cpu-cycles.dcache=
_readdir.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.68,=0A  =
  0.69,=0A    0.67,=0A    0.68,=0A    0.68=0A  ],=0A  "perf-profile.cpu-cyc=
les.__d_lookup_rcu.lookup_fast.path_lookupat.filename_lookup.user_path_at_e=
mpty": [=0A    0.65,=0A    0.62,=0A    0.63,=0A    0.63,=0A    0.63=0A  ],=
=0A  "perf-profile.cpu-cycles.__d_alloc.d_alloc.dcache_dir_open.do_dentry_o=
pen.finish_open": [=0A    0.64,=0A    0.64,=0A    0.66,=0A    0.65,=0A    0=
=2E68=0A  ],=0A  "perf-profile.cpu-cycles.free_pcppages_bulk.free_hot_cold_=
page.free_hot_cold_page_list.release_pages.__pagevec_release": [=0A    0.6,=
=0A    0.58,=0A    0.59,=0A    0.59,=0A    0.59=0A  ],=0A  "perf-profile.cp=
u-cycles.memchr": [=0A    0.55,=0A    0.54,=0A    0.53,=0A    0.55,=0A    0=
=2E6=0A  ],=0A  "perf-profile.cpu-cycles.check_kill_permission.group_send_s=
ig_info.kill_pid_info.SYSC_kill.sys_kill": [=0A    0.55,=0A    0.4,=0A    0=
=2E29,=0A    0.53,=0A    0.38=0A  ],=0A  "perf-profile.cpu-cycles.d_set_d_o=
p.__d_alloc.d_alloc.dcache_dir_open.do_dentry_open": [=0A    0.53,=0A    0.=
52,=0A    0.53,=0A    0.54,=0A    0.52=0A  ],=0A  "perf-profile.cpu-cycles.=
filldir.dcache_readdir.iterate_dir.sys_getdents.system_call_fastpath": [=0A=
    0.49,=0A    0.49,=0A    0.49,=0A    0.49,=0A    0.49=0A  ],=0A  "perf-p=
rofile.cpu-cycles.readdir64": [=0A    0.47,=0A    0.46,=0A    0.47,=0A    0=
=2E46,=0A    0.48=0A  ],=0A  "perf-profile.cpu-cycles._IO_fgets": [=0A    0=
=2E47,=0A    0.46,=0A    0.49,=0A    0.43,=0A    0.47=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__mem_cgroup_commit_charge.mem_cgroup_charge_file.__add_to_p=
age_cache_locked.add_to_page_cache_lru.pagecache_get_page": [=0A    0.47,=
=0A    0.48,=0A    0.48,=0A    0.47,=0A    0.48=0A  ],=0A  "perf-profile.cp=
u-cycles.do_dentry_open.finish_open.do_last.path_openat.do_filp_open": [=0A=
    0.47,=0A    0.44,=0A    0.45,=0A    0.48,=0A    0.47=0A  ],=0A  "perf-p=
rofile.cpu-cycles.__d_free.rcu_nocb_kthread.kthread.ret_from_fork": [=0A   =
 0.46,=0A    0.46,=0A    0.46,=0A    0.46,=0A    0.46=0A  ],=0A  "perf-prof=
ile.cpu-cycles.find_get_entries.pagevec_lookup_entries.truncate_inode_pages=
_range.truncate_inode_pages_final.evict": [=0A    0.46,=0A    0.45,=0A    0=
=2E45,=0A    0.44,=0A    0.45=0A  ],=0A  "perf-profile.cpu-cycles.link_path=
_walk.path_openat.do_filp_open.do_sys_open.sys_openat": [=0A    0.42,=0A   =
 0.39,=0A    0.42,=0A    0.4,=0A    0.42=0A  ],=0A  "perf-profile.cpu-cycle=
s.__radix_tree_lookup.radix_tree_lookup_slot.find_get_entry.pagecache_get_p=
age.generic_file_read_iter": [=0A    0.4,=0A    0.43,=0A    0.41,=0A    0.4=
1,=0A    0.42=0A  ],=0A  "perf-profile.cpu-cycles.malloc": [=0A    0.38,=0A=
    0.34,=0A    0.31,=0A    0.33,=0A    0.33=0A  ],=0A  "perf-profile.cpu-c=
ycles.__d_lookup_rcu.lookup_fast.link_path_walk.path_openat.do_filp_open": =
[=0A    0.36,=0A    0.41,=0A    0.38,=0A    0.37,=0A    0.37=0A  ],=0A  "pe=
rf-profile.cpu-cycles.__d_alloc.d_alloc.lookup_dcache.__lookup_hash.lookup_=
slow": [=0A    0.34,=0A    0.33,=0A    0.35,=0A    0.34,=0A    0.36=0A  ],=
=0A  "perf-profile.cpu-cycles.find_pid_ns.find_vpid.SYSC_kill.sys_kill.syst=
em_call_fastpath": [=0A    0.34,=0A    0.25,=0A    0.33,=0A    0.26,=0A    =
0.24=0A  ],=0A  "perf-profile.cpu-cycles.link_path_walk.path_openat.do_filp=
_open.do_sys_open.sys_open": [=0A    0.34,=0A    0.32,=0A    0.34,=0A    0.=
33,=0A    0.35=0A  ],=0A  "perf-profile.cpu-cycles._IO_getline_info": [=0A =
   0.33,=0A    0.33,=0A    0.32,=0A    0.31,=0A    0.32=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.__list_add.dcache_readdir.iterate_dir.sys_getdents.system_=
call_fastpath": [=0A    0.33,=0A    0.33,=0A    0.33,=0A    0.32,=0A    0.3=
3=0A  ],=0A  "perf-profile.cpu-cycles.avc_has_perm.current_has_perm.selinux=
_task_kill.security_task_kill.check_kill_permission": [=0A    0.32,=0A    0=
=2E34,=0A    0.33,=0A    0.41,=0A    0.32=0A  ],=0A  "perf-profile.cpu-cycl=
es.generic_permission.__inode_permission.inode_permission.link_path_walk.pa=
th_lookupat": [=0A    0.29,=0A    0.35,=0A    0.31,=0A    0.34,=0A    0.3=
=0A  ],=0A  "perf-profile.cpu-cycles.strchr@plt": [=0A    0.29,=0A    0.28,=
=0A    0.29,=0A    0.29,=0A    0.3=0A  ],=0A  "perf-profile.cpu-cycles.pid_=
vnr.SYSC_kill.sys_kill.system_call_fastpath.kill": [=0A    0.29,=0A    0.31=
,=0A    0.24,=0A    0.22,=0A    0.22=0A  ],=0A  "perf-profile.cpu-cycles.pa=
th_init.path_lookupat.filename_lookup.user_path_at_empty.user_path_at": [=
=0A    0.28,=0A    0.25,=0A    0.26,=0A    0.26,=0A    0.25=0A  ],=0A  "per=
f-profile.cpu-cycles.do_last.path_openat.do_filp_open.do_sys_open.sys_opena=
t": [=0A    0.27,=0A    0.24,=0A    0.25,=0A    0.25,=0A    0.25=0A  ],=0A =
 "perf-profile.cpu-cycles.do_last.path_openat.do_filp_open.do_sys_open.sys_=
open": [=0A    0.26,=0A    0.23,=0A    0.23,=0A    0.25,=0A    0.25=0A  ],=
=0A  "perf-profile.cpu-cycles.kmem_cache_free.final_putname.putname.user_pa=
th_at_empty.user_path_at": [=0A    0.26,=0A    0.25,=0A    0.25,=0A    0.25=
,=0A    0.26=0A  ],=0A  "perf-profile.cpu-cycles.get_page_from_freelist.__a=
lloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_pa=
ge": [=0A    0.26,=0A    0.25,=0A    0.26,=0A    0.26,=0A    0.26=0A  ],=0A=
  "perf-profile.cpu-cycles.memset.generic_perform_write.__generic_file_writ=
e_iter.generic_file_write_iter.new_sync_write": [=0A    0.26,=0A    0.26,=
=0A    0.27,=0A    0.26,=0A    0.27=0A  ],=0A  "perf-profile.cpu-cycles.gen=
eric_file_read_iter.new_sync_read.vfs_read.sys_pread64.system_call_fastpath=
": [=0A    0.25,=0A    0.26,=0A    0.26,=0A    0.27,=0A    0.27=0A  ],=0A  =
"perf-profile.cpu-cycles.kill": [=0A    0.25,=0A    0.24,=0A    0.26,=0A   =
 0.23,=0A    0.26=0A  ],=0A  "perf-profile.cpu-cycles.inode_init_always.all=
oc_inode.new_inode_pseudo.new_inode.ramfs_get_inode": [=0A    0.25,=0A    0=
=2E24,=0A    0.25,=0A    0.26,=0A    0.26=0A  ],=0A  "perf-profile.cpu-cycl=
es.__fput.____fput.task_work_run.do_notify_resume.int_signal": [=0A    0.25=
,=0A    0.24,=0A    0.25,=0A    0.25,=0A    0.24=0A  ],=0A  "perf-profile.c=
pu-cycles.copy_page_to_iter_iovec.copy_page_to_iter.generic_file_read_iter.=
new_sync_read.vfs_read": [=0A    0.25,=0A    0.27,=0A    0.27,=0A    0.26,=
=0A    0.26=0A  ],=0A  "perf-profile.cpu-cycles.kmem_cache_alloc.get_empty_=
filp.path_openat.do_filp_open.do_sys_open": [=0A    0.24,=0A    0.26,=0A   =
 0.24,=0A    0.25,=0A    0.25=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin=
_unlock.dcache_readdir.iterate_dir.sys_getdents.system_call_fastpath": [=0A=
    0.24,=0A    0.25,=0A    0.26,=0A    0.25,=0A    0.25=0A  ],=0A  "perf-p=
rofile.cpu-cycles.kfree.selinux_file_free_security.security_file_free.__fpu=
t.____fput": [=0A    0.24,=0A    0.24,=0A    0.22,=0A    0.23,=0A    0.24=
=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_lock.free_one_page.__free_pa=
ges_ok.__free_pages.__free_slab": [=0A    0.24,=0A    0.21,=0A    0.37,=0A =
   0.34,=0A    0.15=0A  ],=0A  "perf-profile.cpu-cycles.d_set_d_op.__d_allo=
c.d_alloc.lookup_dcache.__lookup_hash": [=0A    0.23,=0A    0.24,=0A    0.2=
4,=0A    0.24,=0A    0.23=0A  ],=0A  "perf-profile.cpu-cycles.task_work_run=
=2Edo_notify_resume.int_signal.close": [=0A    0.23,=0A    0.24,=0A    0.24=
,=0A    0.23,=0A    0.23=0A  ],=0A  "perf-profile.cpu-cycles.SYSC_kill.sys_=
kill.system_call_fastpath.kill": [=0A    0.23,=0A    0.22,=0A    0.23,=0A  =
  0.26,=0A    0.24=0A  ],=0A  "perf-profile.cpu-cycles.strtol": [=0A    0.2=
3,=0A    0.24,=0A    0.23,=0A    0.21,=0A    0.28=0A  ],=0A  "perf-profile.=
cpu-cycles.put_page.generic_file_read_iter.new_sync_read.vfs_read.sys_pread=
64": [=0A    0.23,=0A    0.23,=0A    0.23,=0A    0.23,=0A    0.23=0A  ],=0A=
  "perf-profile.cpu-cycles.__inode_permission.inode_permission.link_path_wa=
lk.path_lookupat.filename_lookup": [=0A    0.22,=0A    0.22,=0A    0.23,=0A=
    0.23,=0A    0.22=0A  ],=0A  "perf-profile.cpu-cycles.__list_del_entry.l=
ist_del.__rmqueue.get_page_from_freelist.__alloc_pages_nodemask": [=0A    0=
=2E22,=0A    0.21,=0A    0.22,=0A    0.22,=0A    0.21=0A  ],=0A  "perf-prof=
ile.cpu-cycles.update_cfs_rq_blocked_load.task_tick_fair.scheduler_tick.upd=
ate_process_times.tick_sched_handle": [=0A    0.22,=0A    0.23,=0A    0.22,=
=0A    0.22,=0A    0.2=0A  ],=0A  "perf-profile.cpu-cycles.free": [=0A    0=
=2E21,=0A    0.21,=0A    0.19,=0A    0.2,=0A    0.19=0A  ],=0A  "perf-profi=
le.cpu-cycles.kmem_cache_alloc.getname_flags.user_path_at_empty.user_path_a=
t.vfs_fstatat": [=0A    0.21,=0A    0.24,=0A    0.21,=0A    0.22,=0A    0.2=
1=0A  ],=0A  "perf-profile.cpu-cycles.generic_permission.__inode_permission=
=2Einode_permission.link_path_walk.path_openat": [=0A    0.2,=0A    0.23,=
=0A    0.23,=0A    0.25,=0A    0.21=0A  ],=0A  "perf-profile.cpu-cycles.do_=
sys_open.sys_openat.system_call_fastpath": [=0A    0.2,=0A    0.2,=0A    0.=
22,=0A    0.2,=0A    0.21=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_loc=
k.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.2,=0A    0.2,=
=0A    0.19,=0A    0.19,=0A    0.2=0A  ],=0A  "perf-profile.cpu-cycles.path=
_lookupat.filename_lookup.user_path_at_empty.user_path_at.vfs_fstatat": [=
=0A    0.19,=0A    0.2,=0A    0.2,=0A    0.19,=0A    0.19=0A  ],=0A  "perf-=
profile.cpu-cycles.fsnotify.security_file_open.do_dentry_open.finish_open.d=
o_last": [=0A    0.19,=0A    0.19,=0A    0.2,=0A    0.2,=0A    0.2=0A  ],=
=0A  "perf-profile.cpu-cycles.__xstat64": [=0A    0.19,=0A    0.19,=0A    0=
=2E17,=0A    0.18,=0A    0.17=0A  ],=0A  "perf-profile.cpu-cycles.__list_de=
l_entry.list_del.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_=
current": [=0A    0.19,=0A    0.19,=0A    0.19,=0A    0.19,=0A    0.19=0A  =
],=0A  "perf-profile.cpu-cycles.inode_permission.path_lookupat.filename_loo=
kup.user_path_at_empty.user_path_at": [=0A    0.18,=0A    0.2,=0A    0.19,=
=0A    0.19,=0A    0.19=0A  ],=0A  "perf-profile.cpu-cycles.__ctype_b_loc":=
 [=0A    0.18,=0A    0.17,=0A    0.15,=0A    0.17,=0A    0.16=0A  ],=0A  "p=
erf-profile.cpu-cycles.lookup_fast.link_path_walk.path_lookupat.filename_lo=
okup.user_path_at_empty": [=0A    0.18,=0A    0.18,=0A    0.19,=0A    0.17,=
=0A    0.18=0A  ],=0A  "perf-profile.cpu-cycles.system_call_after_swapgs.ki=
ll": [=0A    0.18,=0A    0.2,=0A    0.17,=0A    0.18,=0A    0.17=0A  ],=0A =
 "perf-profile.cpu-cycles.kmem_cache_alloc_trace.selinux_file_alloc_securit=
y.security_file_alloc.get_empty_filp.path_openat": [=0A    0.18,=0A    0.2,=
=0A    0.18,=0A    0.19,=0A    0.19=0A  ],=0A  "perf-profile.cpu-cycles.__c=
all_rcu_nocb_enqueue.__call_rcu.call_rcu_sched.__fput.____fput": [=0A    0.=
18,=0A    0.17,=0A    0.19,=0A    0.18,=0A    0.18=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.__mnt_want_write.do_dentry_open.finish_open.do_last.path_open=
at": [=0A    0.17,=0A    0.17,=0A    0.18,=0A    0.19,=0A    0.17=0A  ],=0A=
  "perf-profile.cpu-cycles.__radix_tree_lookup.radix_tree_lookup_slot.find_=
get_entry.pagecache_get_page.grab_cache_page_write_begin": [=0A    0.17,=0A=
    0.16,=0A    0.16,=0A    0.16,=0A    0.16=0A  ],=0A  "perf-profile.cpu-c=
ycles.touch_atime.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0=
=2E17,=0A    0.16,=0A    0.17,=0A    0.15,=0A    0.16=0A  ],=0A  "perf-prof=
ile.cpu-cycles.system_call.kill": [=0A    0.17,=0A    0.16,=0A    0.16,=0A =
   0.16,=0A    0.16=0A  ],=0A  "perf-profile.cpu-cycles.generic_fillattr.si=
mple_getattr.vfs_getattr_nosec.vfs_getattr.vfs_fstatat": [=0A    0.17,=0A  =
  0.16,=0A    0.19,=0A    0.19,=0A    0.18=0A  ],=0A  "perf-profile.cpu-cyc=
les.inode_has_perm.isra.32.selinux_inode_getattr.security_inode_getattr.vfs=
_getattr.vfs_fstatat": [=0A    0.16,=0A    0.17,=0A    0.18,=0A    0.18,=0A=
    0.17=0A  ],=0A  "perf-profile.cpu-cycles.current_has_perm.selinux_task_=
kill.security_task_kill.check_kill_permission.group_send_sig_info": [=0A   =
 0.16,=0A    0.12,=0A    0.21,=0A    0.15,=0A    0.1=0A  ],=0A  "perf-profi=
le.cpu-cycles._raw_spin_lock.new_inode_pseudo.new_inode.ramfs_get_inode.ram=
fs_mknod": [=0A    0.16,=0A    0.16,=0A    0.17,=0A    0.17,=0A    0.16=0A =
 ],=0A  "perf-profile.cpu-cycles.kmem_cache_free.__d_free.dentry_free.__den=
try_kill.dput": [=0A    0.16,=0A    0.18,=0A    0.18,=0A    0.17,=0A    0.1=
7=0A  ],=0A  "perf-profile.cpu-cycles.__call_rcu_nocb_enqueue.__call_rcu.ca=
ll_rcu_sched.dentry_free.__dentry_kill": [=0A    0.16,=0A    0.15,=0A    0.=
16,=0A    0.16,=0A    0.16=0A  ],=0A  "perf-profile.cpu-cycles.avc_has_perm=
=2Einode_has_perm.selinux_inode_getattr.security_inode_getattr.vfs_getattr"=
: [=0A    0.16,=0A    0.16,=0A    0.14,=0A    0.15,=0A    0.15=0A  ],=0A  "=
perf-profile.cpu-cycles.page_waitqueue.simple_write_end.generic_perform_wri=
te.__generic_file_write_iter.generic_file_write_iter": [=0A    0.16,=0A    =
0.15,=0A    0.15,=0A    0.15,=0A    0.14=0A  ],=0A  "perf-profile.cpu-cycle=
s.__inode_permission.inode_permission.link_path_walk.path_openat.do_filp_op=
en": [=0A    0.15,=0A    0.15,=0A    0.16,=0A    0.16,=0A    0.15=0A  ],=0A=
  "perf-profile.cpu-cycles.__slab_free.kmem_cache_free.i_callback.rcu_nocb_=
kthread.kthread": [=0A    0.15,=0A    0.16,=0A    0.17,=0A    0.16,=0A    0=
=2E16=0A  ],=0A  "perf-profile.cpu-cycles.lookup_fast.link_path_walk.path_o=
penat.do_filp_open.do_sys_open": [=0A    0.15,=0A    0.15,=0A    0.16,=0A  =
  0.15,=0A    0.16=0A  ],=0A  "perf-profile.cpu-cycles.__slab_free.kmem_cac=
he_free.file_free_rcu.rcu_nocb_kthread.kthread": [=0A    0.15,=0A    0.15,=
=0A    0.14,=0A    0.15,=0A    0.14=0A  ],=0A  "perf-profile.cpu-cycles.tas=
k_tick_fair.scheduler_tick.update_process_times.tick_sched_handle.tick_sche=
d_timer": [=0A    0.15,=0A    0.16,=0A    0.15,=0A    0.15,=0A    0.14=0A  =
],=0A  "perf-profile.cpu-cycles.iterate_dir.sys_getdents.system_call_fastpa=
th": [=0A    0.14,=0A    0.15,=0A    0.15,=0A    0.14,=0A    0.15=0A  ],=0A=
  "perf-profile.cpu-cycles.__call_rcu.call_rcu_sched.__fput.____fput.task_w=
ork_run": [=0A    0.14,=0A    0.14,=0A    0.15,=0A    0.15,=0A    0.15=0A  =
],=0A  "perf-profile.cpu-cycles.__wake_up_bit.unlock_page.simple_write_end.=
generic_perform_write.__generic_file_write_iter": [=0A    0.14,=0A    0.14,=
=0A    0.14,=0A    0.15,=0A    0.14=0A  ],=0A  "perf-profile.cpu-cycles.__m=
ight_sleep.might_fault.filldir.dcache_readdir.iterate_dir": [=0A    0.14,=
=0A    0.14,=0A    0.14,=0A    0.14,=0A    0.14=0A  ],=0A  "perf-profile.cp=
u-cycles.generic_perform_write.__generic_file_write_iter.generic_file_write=
_iter.new_sync_write.vfs_write": [=0A    0.13,=0A    0.13,=0A    0.13,=0A  =
  0.12,=0A    0.14=0A  ],=0A  "perf-profile.cpu-cycles.touch_atime.generic_=
file_read_iter.new_sync_read.vfs_read.sys_pread64": [=0A    0.13,=0A    0.1=
4,=0A    0.15,=0A    0.13,=0A    0.14=0A  ],=0A  "perf-profile.cpu-cycles._=
_rmqueue.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.=
__page_cache_alloc": [=0A    0.13,=0A    0.13,=0A    0.13,=0A    0.14,=0A  =
  0.13=0A  ],=0A  "perf-profile.cpu-cycles.__list_del_entry.list_del.releas=
e_pages.__pagevec_release.truncate_inode_pages_range": [=0A    0.13,=0A    =
0.13,=0A    0.13,=0A    0.13,=0A    0.12=0A  ],=0A  "perf-profile.cpu-cycle=
s.do_sys_open.sys_open.system_call_fastpath.open64": [=0A    0.13,=0A    0.=
13,=0A    0.14,=0A    0.13,=0A    0.14=0A  ],=0A  "perf-profile.cpu-cycles.=
getname_flags.user_path_at_empty.user_path_at.vfs_fstatat.SYSC_newstat": [=
=0A    0.13,=0A    0.13,=0A    0.12,=0A    0.13,=0A    0.12=0A  ],=0A  "per=
f-profile.cpu-cycles.kmem_cache_alloc.__d_alloc.d_alloc.lookup_dcache.__loo=
kup_hash": [=0A    0.12,=0A    0.16,=0A    0.1,=0A    0.15,=0A    0.12=0A  =
],=0A  "perf-profile.cpu-cycles.path_init.path_openat.do_filp_open.do_sys_o=
pen.sys_openat": [=0A    0.12,=0A    0.11,=0A    0.11,=0A    0.11,=0A    0.=
1=0A  ],=0A  "perf-profile.cpu-cycles.__slab_free.kmem_cache_free.__d_free.=
rcu_nocb_kthread.kthread": [=0A    0.12,=0A    0.12,=0A    0.12,=0A    0.12=
,=0A    0.12=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_permission.se=
curity_file_permission.iterate_dir.sys_getdents.system_call_fastpath": [=0A=
    0.12,=0A    0.12,=0A    0.11,=0A    0.12,=0A    0.11=0A  ],=0A  "perf-p=
rofile.cpu-cycles.task_work_add.filp_close.__close_fd.sys_close.system_call=
_fastpath": [=0A    0.12,=0A    0.11,=0A    0.11,=0A    0.11,=0A    0.12=0A=
  ],=0A  "perf-profile.cpu-cycles.kmem_cache_alloc.selinux_inode_alloc_secu=
rity.security_inode_alloc.inode_init_always.alloc_inode": [=0A    0.12,=0A =
   0.11,=0A    0.11,=0A    0.12,=0A    0.11=0A  ],=0A  "perf-profile.cpu-cy=
cles.memset.get_empty_filp.path_openat.do_filp_open.do_sys_open": [=0A    0=
=2E12,=0A    0.13,=0A    0.12,=0A    0.12,=0A    0.12=0A  ],=0A  "perf-prof=
ile.cpu-cycles.lookup_fast.path_lookupat.filename_lookup.user_path_at_empty=
=2Euser_path_at": [=0A    0.11,=0A    0.12,=0A    0.12,=0A    0.12,=0A    0=
=2E12=0A  ],=0A  "perf-profile.cpu-cycles.pagecache_get_page.grab_cache_pag=
e_write_begin.simple_write_begin.generic_perform_write.__generic_file_write=
_iter": [=0A    0.11,=0A    0.11,=0A    0.1,=0A    0.11,=0A    0.11=0A  ],=
=0A  "perf-profile.cpu-cycles.__fget_light.sys_getdents.system_call_fastpat=
h": [=0A    0.11,=0A    0.12,=0A    0.11,=0A    0.12,=0A    0.12=0A  ],=0A =
 "perf-profile.cpu-cycles.__destroy_inode.destroy_inode.evict.iput.do_unlin=
kat": [=0A    0.11,=0A    0.1,=0A    0.11,=0A    0.12,=0A    0.12=0A  ],=0A=
  "perf-profile.cpu-cycles.__alloc_pages_nodemask.alloc_pages_current.__pag=
e_cache_alloc.pagecache_get_page.grab_cache_page_write_begin": [=0A    0.11=
,=0A    0.11,=0A    0.11,=0A    0.11,=0A    0.12=0A  ],=0A  "perf-profile.c=
pu-cycles.kmem_cache_alloc.__d_alloc.d_alloc.dcache_dir_open.do_dentry_open=
": [=0A    0.11,=0A    0.16,=0A    0.1,=0A    0.15,=0A    0.12=0A  ],=0A  "=
perf-profile.cpu-cycles.may_open.do_last.path_openat.do_filp_open.do_sys_op=
en": [=0A    0.11,=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.1=0A  ],=0A =
 "perf-profile.cpu-cycles.__fget_light.sys_pread64.system_call_fastpath.pre=
ad64": [=0A    0.11,=0A    0.11,=0A    0.09,=0A    0.12,=0A    0.1=0A  ],=
=0A  "perf-profile.cpu-cycles.kmem_cache_free.final_putname.putname.do_sys_=
open.sys_openat": [=0A    0.11,=0A    0.11,=0A    0.1,=0A    0.1,=0A    0.0=
9=0A  ],=0A  "perf-profile.cpu-cycles.__mnt_want_write.mnt_want_write.do_la=
st.path_openat.do_filp_open": [=0A    0.11,=0A    0.1,=0A    0.11,=0A    0.=
12,=0A    0.1=0A  ],=0A  "perf-profile.cpu-cycles.__delete_from_page_cache.=
delete_from_page_cache.truncate_inode_page.truncate_inode_pages_range.trunc=
ate_inode_pages_final": [=0A    0.11,=0A    0.11,=0A    0.12,=0A    0.11,=
=0A    0.11=0A  ],=0A  "perf-profile.cpu-cycles.avc_has_perm.inode_has_perm=
=2Eselinux_file_open.security_file_open.do_dentry_open": [=0A    0.11,=0A  =
  0.14,=0A    0.11,=0A    0.12,=0A    0.12=0A  ],=0A  "perf-profile.cpu-cyc=
les.__call_rcu.call_rcu_sched.dentry_free.__dentry_kill.dput": [=0A    0.11=
,=0A    0.1,=0A    0.11,=0A    0.1,=0A    0.1=0A  ],=0A  "perf-profile.cpu-=
cycles.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.=
grab_cache_page_write_begin.simple_write_begin": [=0A    0.11,=0A    0.11,=
=0A    0.11,=0A    0.11,=0A    0.11=0A  ],=0A  "perf-profile.cpu-cycles.mig=
ht_fault.dcache_readdir.iterate_dir.sys_getdents.system_call_fastpath": [=
=0A    0.11,=0A    0.11,=0A    0.11,=0A    0.11,=0A    0.11=0A  ],=0A  "per=
f-profile.cpu-cycles.strncpy_from_user.getname_flags.user_path_at_empty.use=
r_path_at.vfs_fstatat": [=0A    0.1,=0A    0.1,=0A    0.11,=0A    0.1,=0A  =
  0.11=0A  ],=0A  "perf-profile.cpu-cycles.simple_write_end.__generic_file_=
write_iter.generic_file_write_iter.new_sync_write.vfs_write": [=0A    0.1,=
=0A    0.07,=0A    0.07,=0A    0.09,=0A    0.08=0A  ],=0A  "perf-profile.cp=
u-cycles.__might_sleep.generic_file_read_iter.new_sync_read.vfs_read.sys_pr=
ead64": [=0A    0.1,=0A    0.09,=0A    0.1,=0A    0.1,=0A    0.09=0A  ],=0A=
  "perf-profile.cpu-cycles.__d_lookup_rcu.lookup_fast.do_last.path_openat.d=
o_filp_open": [=0A    0.1,=0A    0.1,=0A    0.1,=0A    0.1,=0A    0.1=0A  ]=
,=0A  "perf-profile.cpu-cycles.lockref_get_not_dead.complete_walk.path_look=
upat.filename_lookup.user_path_at_empty": [=0A    0.1,=0A    0.1,=0A    0.1=
,=0A    0.1,=0A    0.1=0A  ],=0A  "perf-profile.cpu-cycles.sys_getdents.sys=
tem_call_fastpath": [=0A    0.1,=0A    0.09,=0A    0.09,=0A    0.09,=0A    =
0.1=0A  ],=0A  "perf-profile.cpu-cycles.iov_iter_fault_in_readable.generic_=
perform_write.__generic_file_write_iter.generic_file_write_iter.new_sync_wr=
ite": [=0A    0.09,=0A    0.09,=0A    0.1,=0A    0.09,=0A    0.1=0A  ],=0A =
 "perf-profile.cpu-cycles.security_inode_permission.inode_permission.link_p=
ath_walk.path_lookupat.filename_lookup": [=0A    0.09,=0A    0.12,=0A    0.=
09,=0A    0.1,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.__radix_tree_=
create.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.=
grab_cache_page_write_begin": [=0A    0.09,=0A    0.09,=0A    0.09,=0A    0=
=2E09,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.cmpxchg_double_slab.i=
sra.51.__slab_free.kmem_cache_free.__d_free.rcu_nocb_kthread": [=0A    0.09=
,=0A    0.18,=0A    0.23,=0A    0.28,=0A    0.21=0A  ],=0A  "perf-profile.c=
pu-cycles.selinux_file_open.security_file_open.do_dentry_open.finish_open.d=
o_last": [=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.1=0A  ],=
=0A  "perf-profile.cpu-cycles.vfs_read.sys_pread64.system_call_fastpath.pre=
ad64": [=0A    0.09,=0A    0.1,=0A    0.09,=0A    0.09,=0A    0.09=0A  ],=
=0A  "perf-profile.cpu-cycles.cp_new_stat.SYSC_newstat.sys_newstat.system_c=
all_fastpath.__xstat64": [=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.09,=
=0A    0.1=0A  ],=0A  "perf-profile.cpu-cycles.release_pages.__pagevec_rele=
ase.truncate_inode_pages_range.truncate_inode_pages_final.evict": [=0A    0=
=2E09,=0A    0.1,=0A    0.1,=0A    0.1,=0A    0.09=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.snprintf": [=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.08,=
=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.__pagevec_lru_add_fn.pageve=
c_lru_move_fn.__lru_cache_add.lru_cache_add.add_to_page_cache_lru": [=0A   =
 0.09,=0A    0.08,=0A    0.09,=0A    0.09,=0A    0.08=0A  ],=0A  "perf-prof=
ile.cpu-cycles.drop_nlink.simple_unlink.vfs_unlink.do_unlinkat.sys_unlink":=
 [=0A    0.09,=0A    0.09,=0A    0.1,=0A    0.11,=0A    0.09=0A  ],=0A  "pe=
rf-profile.cpu-cycles.alloc_pages_current.__page_cache_alloc.pagecache_get_=
page.grab_cache_page_write_begin.simple_write_begin": [=0A    0.09,=0A    0=
=2E09,=0A    0.08,=0A    0.08,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycl=
es.sys_kill.kill": [=0A    0.09,=0A    0.09,=0A    0.08,=0A    0.07,=0A    =
0.09=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.kmem_cache_alloc.sel=
inux_inode_alloc_security.security_inode_alloc.inode_init_always": [=0A    =
0.09,=0A    0.08,=0A    0.09,=0A    0.09,=0A    0.09=0A  ],=0A  "perf-profi=
le.cpu-cycles.fput.filp_close.__close_fd.sys_close.system_call_fastpath": [=
=0A    0.08,=0A    0.08,=0A    0.09,=0A    0.08,=0A    0.09=0A  ],=0A  "per=
f-profile.cpu-cycles.free_hot_cold_page.free_hot_cold_page_list.release_pag=
es.__pagevec_release.truncate_inode_pages_range": [=0A    0.08,=0A    0.07,=
=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.ram=
fs_get_inode.ramfs_mknod.ramfs_create.vfs_create.do_last": [=0A    0.08,=0A=
    0.08,=0A    0.09,=0A    0.09,=0A    0.09=0A  ],=0A  "perf-profile.cpu-c=
ycles.do_notify_resume.int_signal.close": [=0A    0.08,=0A    0.09,=0A    0=
=2E1,=0A    0.09,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.new_slab._=
_slab_alloc.kmem_cache_alloc.get_empty_filp.path_openat": [=0A    0.08,=0A =
   0.08,=0A    0.08,=0A    0.09,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cy=
cles.open64": [=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.07,=0A    0.08=
=0A  ],=0A  "perf-profile.cpu-cycles.__libc_calloc": [=0A    0.08,=0A    0.=
08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.=
__strdup": [=0A    0.08,=0A    0.09,=0A    0.06,=0A    0.07,=0A    0.06=0A =
 ],=0A  "perf-profile.cpu-cycles.file_ra_state_init.finish_open.do_last.pat=
h_openat.do_filp_open": [=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08,=
=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles._copy_to_user.dcache_readdi=
r.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.08,=0A    0.08,=
=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.tru=
ncate_inode_pages_range.truncate_inode_pages_final.evict.iput.do_unlinkat":=
 [=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "p=
erf-profile.cpu-cycles.path_init.path_openat.do_filp_open.do_sys_open.sys_o=
pen": [=0A    0.08,=0A    0.07,=0A    0.08,=0A    0.07,=0A    0.07=0A  ],=
=0A  "perf-profile.cpu-cycles.kmem_cache_free.final_putname.putname.do_sys_=
open.sys_open": [=0A    0.08,=0A    0.07,=0A    0.08,=0A    0.08,=0A    0.0=
8=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_permission.security_file=
_permission.rw_verify_area.vfs_read.sys_pread64": [=0A    0.08,=0A    0.07,=
=0A    0.07,=0A    0.09,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.__l=
ist_del_entry.selinux_inode_free_security.security_inode_free.__destroy_ino=
de.destroy_inode": [=0A    0.08,=0A    0.07,=0A    0.08,=0A    0.07,=0A    =
0.07=0A  ],=0A  "perf-profile.cpu-cycles.mutex_unlock.sys_getdents.system_c=
all_fastpath": [=0A    0.08,=0A    0.08,=0A    0.07,=0A    0.08,=0A    0.08=
=0A  ],=0A  "perf-profile.cpu-cycles.mutex_lock_killable.iterate_dir.sys_ge=
tdents.system_call_fastpath": [=0A    0.08,=0A    0.08,=0A    0.07,=0A    0=
=2E08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.__d_drop.dput.termina=
te_walk.path_lookupat.filename_lookup": [=0A    0.08,=0A    0.08,=0A    0.0=
8,=0A    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.memcpy.d_allo=
c.dcache_dir_open.do_dentry_open.finish_open": [=0A    0.08,=0A    0.07,=0A=
    0.07,=0A    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.__migh=
t_sleep.generic_perform_write.__generic_file_write_iter.generic_file_write_=
iter.new_sync_write": [=0A    0.08,=0A    0.08,=0A    0.07,=0A    0.07,=0A =
   0.06=0A  ],=0A  "perf-profile.cpu-cycles.kmem_cache_alloc.getname_flags.=
getname.do_sys_open.sys_openat": [=0A    0.07,=0A    0.08,=0A    0.07,=0A  =
  0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_lock_irqsa=
ve.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.new_sl=
ab": [=0A    0.07,=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A=
  "perf-profile.cpu-cycles.fsnotify.iterate_dir.sys_getdents.system_call_fa=
stpath": [=0A    0.07,=0A    0.08,=0A    0.07,=0A    0.08,=0A    0.08=0A  ]=
,=0A  "perf-profile.cpu-cycles.radix_tree_next_chunk.find_get_entries.pagev=
ec_lookup_entries.truncate_inode_pages_range.truncate_inode_pages_final": [=
=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "per=
f-profile.cpu-cycles.__mutex_init.alloc_inode.new_inode_pseudo.new_inode.ra=
mfs_get_inode": [=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.0=
7=0A  ],=0A  "perf-profile.cpu-cycles.__generic_file_write_iter.generic_fil=
e_write_iter.new_sync_write.vfs_write.sys_pwrite64": [=0A    0.07,=0A    0.=
06,=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.=
selinux_inode_permission.security_inode_permission.__inode_permission.inode=
_permission.may_open": [=0A    0.07,=0A    0.06,=0A    0.07,=0A    0.07,=0A=
    0.07=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_unlock.iterate_dir.s=
ys_getdents.system_call_fastpath": [=0A    0.07,=0A    0.07,=0A    0.08,=0A=
    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.find_pid_ns.SYSC_k=
ill.sys_kill.system_call_fastpath.kill": [=0A    0.07,=0A    0.07,=0A    0.=
08,=0A    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.put_page.sim=
ple_write_end.generic_perform_write.__generic_file_write_iter.generic_file_=
write_iter": [=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07=
=0A  ],=0A  "perf-profile.cpu-cycles.strlen@plt": [=0A    0.07,=0A    0.07,=
=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.pre=
ad64": [=0A    0.07,=0A    0.07,=0A    0.09,=0A    0.06,=0A    0.09=0A  ],=
=0A  "perf-profile.cpu-cycles.fgets@plt": [=0A    0.07,=0A    0.05,=0A    0=
=2E06,=0A    0.05,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.selinux_i=
node_permission.__inode_permission.inode_permission.link_path_walk.path_loo=
kupat": [=0A    0.07,=0A    0.08,=0A    0.08,=0A    0.07,=0A    0.08=0A  ],=
=0A  "perf-profile.cpu-cycles.__alloc_fd.get_unused_fd_flags.do_sys_open.sy=
s_openat.system_call_fastpath": [=0A    0.07,=0A    0.09,=0A    0.09,=0A   =
 0.08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.unlock_page.simple_wr=
ite_end.generic_perform_write.__generic_file_write_iter.generic_file_write_=
iter": [=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.06,=0A    0.07=0A  ],=
=0A  "perf-profile.cpu-cycles.__close_fd.sys_close.system_call_fastpath.clo=
se": [=0A    0.07,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06=0A  ],=0A=
  "perf-profile.cpu-cycles.d_lookup.lookup_dcache.__lookup_hash.lookup_slow=
=2Epath_lookupat": [=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07,=0A    =
0.07=0A  ],=0A  "perf-profile.cpu-cycles.vfs_fstatat.SYSC_newstat.sys_newst=
at.system_call_fastpath.__xstat64": [=0A    0.07,=0A    0.06,=0A    0.06,=
=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.update_cfs_shar=
es.task_tick_fair.scheduler_tick.update_process_times.tick_sched_handle": [=
=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.06,=0A    0.06=0A  ],=0A  "per=
f-profile.cpu-cycles.__dentry_kill.dput.dcache_dir_close.__fput.____fput": =
[=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "pe=
rf-profile.cpu-cycles.fsnotify.security_file_permission.iterate_dir.sys_get=
dents.system_call_fastpath": [=0A    0.07,=0A    0.06,=0A    0.07,=0A    0.=
07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.sys_newstat.__xstat64": =
[=0A    0.07,=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "pe=
rf-profile.cpu-cycles.path_openat.do_filp_open.do_sys_open.sys_openat.syste=
m_call_fastpath": [=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.06,=0A    0=
=2E07=0A  ],=0A  "perf-profile.cpu-cycles.lockref_put_or_lock.dput.__fput._=
___fput.task_work_run": [=0A    0.06,=0A    0.06,=0A    0.07,=0A    0.06,=
=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.security_inode_getattr.vfs_=
fstatat.SYSC_newstat.sys_newstat.system_call_fastpath": [=0A    0.06,=0A   =
 0.08,=0A    0.05,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycl=
es.__d_rehash._d_rehash.d_rehash.simple_lookup.lookup_real": [=0A    0.06,=
=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cp=
u-cycles._raw_spin_lock_irqsave.release_pages.__pagevec_release.truncate_in=
ode_pages_range.truncate_inode_pages_final": [=0A    0.06,=0A    0.06,=0A  =
  0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.link_pat=
h_walk.path_lookupat.filename_lookup.user_path_parent.do_unlinkat": [=0A   =
 0.06,=0A    0.06,=0A    0.07,=0A    0.06,=0A    0.07=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__percpu_counter_add.get_empty_filp.path_openat.do_filp_open=
=2Edo_sys_open": [=0A    0.06,=0A    0.07,=0A    0.06,=0A    0.07,=0A    0.=
06=0A  ],=0A  "perf-profile.cpu-cycles.get_mem_cgroup_from_mm.mem_cgroup_tr=
y_charge_mm.mem_cgroup_charge_file.__add_to_page_cache_locked.add_to_page_c=
ache_lru": [=0A    0.06,=0A    0.06,=0A    0.07,=0A    0.07,=0A    0.07=0A =
 ],=0A  "perf-profile.cpu-cycles.mutex_lock_killable.sys_getdents.system_ca=
ll_fastpath": [=0A    0.06,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=
=0A  ],=0A  "perf-profile.cpu-cycles.inode_permission.path_openat.do_filp_o=
pen.do_sys_open.sys_openat": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.=
06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.security_file_open.do_de=
ntry_open.finish_open.do_last.path_openat": [=0A    0.06,=0A    0.05,=0A   =
 0.06,=0A    0.05,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.fsnotify.=
__fput.____fput.task_work_run.do_notify_resume": [=0A    0.06,=0A    0.06,=
=0A    0.07,=0A    0.06,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.fil=
p_close.__close_fd.sys_close.system_call_fastpath.close": [=0A    0.06,=0A =
   0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cy=
cles.dnotify_flush.filp_close.__close_fd.sys_close.system_call_fastpath": [=
=0A    0.06,=0A    0.07,=0A    0.06,=0A    0.06,=0A    0.06=0A  ],=0A  "per=
f-profile.cpu-cycles.sys_close.close": [=0A    0.06,=0A    0.04,=0A    0.05=
,=0A    0.05,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.security_file_=
permission.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.06,=0A=
    0.06,=0A    0.06,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-c=
ycles.memset.selinux_file_alloc_security.security_file_alloc.get_empty_filp=
=2Epath_openat": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.=
06=0A  ],=0A  "perf-profile.cpu-cycles.kill_pid_info.SYSC_kill.sys_kill.sys=
tem_call_fastpath.kill": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=
=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.__fxstat64": [=0A    0.06,=
=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cp=
u-cycles.__list_del_entry.list_del.free_pcppages_bulk.free_hot_cold_page.fr=
ee_hot_cold_page_list": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=
=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.pagecache_get_page.generic_=
file_read_iter.new_sync_read.vfs_read.sys_pread64": [=0A    0.06,=0A    0.0=
6,=0A    0.06,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.g=
et_unused_fd_flags.do_sys_open.sys_openat.system_call_fastpath": [=0A    0.=
06,=0A    0.04,=0A    0.03,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.__slab_alloc.kmem_cache_alloc.get_empty_filp.path_openat.do_f=
ilp_open": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06=0A =
 ],=0A  "perf-profile.cpu-cycles.filename_lookup.user_path_at_empty.user_pa=
th_at.vfs_fstatat.SYSC_newstat": [=0A    0.06,=0A    0.05,=0A    0.06,=0A  =
  0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.generic_fillattr.sim=
ple_getattr.vfs_getattr_nosec.vfs_getattr.vfs_fstat": [=0A    0.06,=0A    0=
=2E06,=0A    0.08,=0A    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycl=
es.process_measurement.ima_file_check.do_last.path_openat.do_filp_open": [=
=0A    0.06,=0A    0.07,=0A    0.06,=0A    0.06,=0A    0.06=0A  ],=0A  "per=
f-profile.cpu-cycles.pagevec_lru_move_fn.__lru_cache_add.lru_cache_add.add_=
to_page_cache_lru.pagecache_get_page": [=0A    0.06,=0A    0.05,=0A    0.06=
,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.bit_waitqueue.=
__inode_wait_for_writeback.inode_wait_for_writeback.evict.iput": [=0A    0.=
06,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.simple_lookup.__lookup_hash.lookup_slow.path_lookupat.filenam=
e_lookup": [=0A    0.06,=0A    0.03,=0A    0.03,=0A    0.05,=0A    0.03=0A =
 ],=0A  "perf-profile.cpu-cycles.lockref_get_not_dead.complete_walk.do_last=
=2Epath_openat.do_filp_open": [=0A    0.06,=0A    0.06,=0A    0.05,=0A    0=
=2E05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.kmem_cache_alloc.getn=
ame_flags.getname.do_sys_open.sys_open": [=0A    0.06,=0A    0.07,=0A    0.=
06,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.lockref_get.=
path_get.do_dentry_open.finish_open.do_last": [=0A    0.06,=0A    0.06,=0A =
   0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__radix=
_tree_lookup.find_get_entry.pagecache_get_page.generic_file_read_iter.new_s=
ync_read": [=0A    0.06,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A =
 ],=0A  "perf-profile.cpu-cycles.get_unused_fd_flags.sys_openat.system_call=
_fastpath": [=0A    0.06,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A=
  ],=0A  "perf-profile.cpu-cycles.lockref_put_or_lock.dput.terminate_walk.d=
o_last.path_openat": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=0A  =
  0.06=0A  ],=0A  "perf-profile.cpu-cycles.new_sync_read.vfs_read.sys_pread=
64.system_call_fastpath.pread64": [=0A    0.05,=0A    0.05,=0A    0.05,=0A =
   0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.cmpxchg_double_slab=
=2Eisra.51.__slab_free.kmem_cache_free.file_free_rcu.rcu_nocb_kthread": [=
=0A    0.05,=0A    0.1,=0A    0.09,=0A    0.12,=0A    0.1=0A  ],=0A  "perf-=
profile.cpu-cycles.cp_new_stat.SYSC_newfstat.sys_newfstat.system_call_fastp=
ath.__fxstat64": [=0A    0.05,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.=
06=0A  ],=0A  "perf-profile.cpu-cycles.dcache_readdir.sys_getdents.system_c=
all_fastpath": [=0A    0.05,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=
=0A  ],=0A  "perf-profile.cpu-cycles.lookup_fast.do_last.path_openat.do_fil=
p_open.do_sys_open": [=0A    0.05,=0A    0.06,=0A    0.06,=0A    0.05,=0A  =
  0.06=0A  ],=0A  "perf-profile.cpu-cycles.__list_del_entry.dcache_readdir.=
iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.05,=0A    0.06,=
=0A    0.05,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.ima=
_file_free.__fput.____fput.task_work_run.do_notify_resume": [=0A    0.05,=
=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cp=
u-cycles.getname_flags.getname.do_sys_open.sys_openat.system_call_fastpath"=
: [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "=
perf-profile.cpu-cycles.__wake_up_bit.unlock_page.truncate_inode_pages_rang=
e.truncate_inode_pages_final.evict": [=0A    0.05,=0A    0.05,=0A    0.05,=
=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__list_del_entr=
y.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.05,=0A    0.05,=
=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.str=
ncpy_from_user.getname_flags.getname.do_sys_open.sys_openat": [=0A    0.05,=
=0A    0.05,=0A    0.06,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cp=
u-cycles.mem_cgroup_try_charge.mem_cgroup_try_charge_mm.mem_cgroup_charge_f=
ile.__add_to_page_cache_locked.add_to_page_cache_lru": [=0A    0.05,=0A    =
0.06,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycle=
s.lockref_put_or_lock.dput.dcache_dir_close.__fput.____fput": [=0A    0.05,=
=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cp=
u-cycles.inode_permission.path_openat.do_filp_open.do_sys_open.sys_open": [=
=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "per=
f-profile.cpu-cycles.user_path_at_empty.user_path_at.vfs_fstatat.SYSC_newst=
at.sys_newstat": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.=
06=0A  ],=0A  "perf-profile.cpu-cycles.copy_from_user_atomic_iovec.generic_=
perform_write.__generic_file_write_iter.generic_file_write_iter.new_sync_wr=
ite": [=0A    0.05,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06=0A  ],=
=0A  "perf-profile.cpu-cycles.selinux_inode_permission.__inode_permission.i=
node_permission.link_path_walk.path_openat": [=0A    0.05,=0A    0.05,=0A  =
  0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.selinux_=
inode_free_security.security_inode_free.__destroy_inode.destroy_inode.evict=
": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  =
"perf-profile.cpu-cycles.__call_rcu_nocb_enqueue.__call_rcu.call_rcu_sched.=
selinux_inode_free_security.security_inode_free": [=0A    0.05,=0A    0.05,=
=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.mut=
ex_lock.lookup_slow.path_lookupat.filename_lookup.user_path_at_empty": [=0A=
    0.05,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-p=
rofile.cpu-cycles._raw_spin_lock_irq.__add_to_page_cache_locked.add_to_page=
_cache_lru.pagecache_get_page.grab_cache_page_write_begin": [=0A    0.05,=
=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cp=
u-cycles.in_group_p.__inode_permission.inode_permission.link_path_walk.path=
_openat": [=0A    0.05,=0A    0.06,=0A    0.05,=0A    0.06,=0A    0.05=0A  =
],=0A  "perf-profile.cpu-cycles.closedir": [=0A    0.05,=0A    0.06,=0A    =
0.05,=0A    0.04,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.ihold.sys_=
unlink.system_call_fastpath.unlink": [=0A    0.05,=0A    0.05,=0A    0.04,=
=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles._IO_getline": [=
=0A    0.05,=0A    0.05,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "per=
f-profile.cpu-cycles.__lru_cache_add.lru_cache_add.add_to_page_cache_lru.pa=
gecache_get_page.grab_cache_page_write_begin": [=0A    0.05,=0A    0.05,=0A=
    0.04,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.put_pa=
ge.new_sync_read.vfs_read.sys_pread64.system_call_fastpath": [=0A    0.05,=
=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cp=
u-cycles.legitimize_mnt.do_last.path_openat.do_filp_open.do_sys_open": [=0A=
    0.05,=0A    0.05,=0A    0.07,=0A    0.05,=0A    0.06=0A  ],=0A  "perf-p=
rofile.cpu-cycles.__slab_alloc.kmem_cache_alloc.__d_alloc.d_alloc.dcache_di=
r_open": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.04,=0A    0.05=0A  ]=
,=0A  "perf-profile.cpu-cycles.page_waitqueue.truncate_inode_pages_range.tr=
uncate_inode_pages_final.evict.iput": [=0A    0.05,=0A    0.05,=0A    0.05,=
=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__fget_light.sy=
s_pwrite64.system_call_fastpath.__libc_pwrite": [=0A    0.05,=0A    0.05,=
=0A    0.04,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.cop=
y_from_user_atomic_iovec.iov_iter_copy_from_user_atomic.generic_perform_wri=
te.__generic_file_write_iter.generic_file_write_iter": [=0A    0.05,=0A    =
0.06,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycle=
s.__list_add.inode_doinit_with_dentry.selinux_d_instantiate.security_d_inst=
antiate.d_instantiate": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.04,=
=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__percpu_counter_add.__fput=
=2E____fput.task_work_run.do_notify_resume": [=0A    0.05,=0A    0.05,=0A  =
  0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__fget_l=
ight.vfs_fstat.SYSC_newfstat.sys_newfstat.system_call_fastpath": [=0A    0.=
05,=0A    0.05,=0A    0.04,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.security_inode_permission.inode_permission.link_path_walk.pat=
h_openat.do_filp_open": [=0A    0.05,=0A    0.07,=0A    0.05,=0A    0.06,=
=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_permission.sec=
urity_file_permission.rw_verify_area.vfs_write.sys_pwrite64": [=0A    0.05,=
=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cp=
u-cycles.legitimize_mnt.path_lookupat.filename_lookup.user_path_at_empty.us=
er_path_at": [=0A    0.05,=0A    0.05,=0A    0.06,=0A    0.06,=0A    0.05=
=0A  ],=0A  "perf-profile.cpu-cycles.in_group_p.__inode_permission.inode_pe=
rmission.link_path_walk.path_lookupat": [=0A    0.05,=0A    0.05,=0A    0.0=
5,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__inode_permi=
ssion.link_path_walk.path_lookupat.filename_lookup.user_path_at_empty": [=
=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "per=
f-profile.cpu-cycles.selinux_file_open.do_dentry_open.finish_open.do_last.p=
ath_openat": [=0A    0.05,=0A    0.06,=0A    0.05,=0A    0.05,=0A    0.05=
=0A  ],=0A  "perf-profile.cpu-cycles.groups_search.in_group_p.generic_permi=
ssion.__inode_permission.inode_permission": [=0A    0.05,=0A    0.05,=0A   =
 0.05,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.SYSC_news=
tat.system_call_fastpath.__xstat64": [=0A    0.05,=0A    0.05,=0A    0.03,=
=0A    0.04,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_page=
_lruvec.pagevec_lru_move_fn.__lru_cache_add.lru_cache_add.add_to_page_cache=
_lru": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=
=0A  "perf-profile.cpu-cycles.free_pages_prepare.free_hot_cold_page.free_ho=
t_cold_page_list.release_pages.__pagevec_release": [=0A    0.04,=0A    0.05=
,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__=
mnt_want_write.mnt_want_write.do_unlinkat.sys_unlink.system_call_fastpath":=
 [=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "p=
erf-profile.cpu-cycles.__alloc_fd.get_unused_fd_flags.do_sys_open.sys_open.=
system_call_fastpath": [=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05,=0A=
    0.05=0A  ],=0A  "perf-profile.cpu-cycles.next_zones_zonelist.__alloc_pa=
ges_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page": [=
=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "per=
f-profile.cpu-cycles.selinux_file_permission.iterate_dir.sys_getdents.syste=
m_call_fastpath": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0=
=2E04=0A  ],=0A  "perf-profile.cpu-cycles.__list_add.d_alloc.lookup_dcache.=
__lookup_hash.lookup_slow": [=0A    0.04,=0A    0.05,=0A    0.04,=0A    0.0=
4,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.lockref_put_or_lock.dput.=
path_put.vfs_fstatat.SYSC_newstat": [=0A    0.04,=0A    0.04,=0A    0.05,=
=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.lookup_slow.pat=
h_lookupat.filename_lookup.user_path_at_empty.user_path_at": [=0A    0.04,=
=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cp=
u-cycles.fsnotify.vfs_read.sys_pread64.system_call_fastpath.pread64": [=0A =
   0.04,=0A    0.04,=0A    0.04,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.do_filp_open.do_sys_open.sys_openat.system_call_fastpath":=
 [=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.04=0A  ],=0A  "p=
erf-profile.cpu-cycles.__srcu_read_lock.fsnotify.vfs_write.sys_pwrite64.sys=
tem_call_fastpath": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A   =
 0.04=0A  ],=0A  "perf-profile.cpu-cycles.strncpy_from_user.getname_flags.g=
etname.do_sys_open.sys_open": [=0A    0.04,=0A    0.04,=0A    0.05,=0A    0=
=2E04,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.vfs_fstatat.sys_newst=
at.system_call_fastpath.__xstat64": [=0A    0.04,=0A    0.04,=0A    0.04,=
=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.__dentry_kill.d=
put.terminate_walk.path_lookupat.filename_lookup": [=0A    0.04,=0A    0.05=
,=0A    0.04,=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.pa=
th_openat.do_filp_open.do_sys_open.sys_open.system_call_fastpath": [=0A    =
0.04,=0A    0.04,=0A    0.05,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profi=
le.cpu-cycles.sysret_check.kill": [=0A    0.04,=0A    0.04,=0A    0.05,=0A =
   0.04,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.add_to_page_cache_l=
ru.pagecache_get_page.grab_cache_page_write_begin.simple_write_begin.generi=
c_perform_write": [=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0=
=2E05=0A  ],=0A  "perf-profile.cpu-cycles.__d_instantiate.d_instantiate.sim=
ple_lookup.lookup_real.__lookup_hash": [=0A    0.04,=0A    0.04,=0A    0.03=
,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.sysret_check._=
_xstat64": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A =
 ],=0A  "perf-profile.cpu-cycles.rw_verify_area.vfs_read.sys_pread64.system=
_call_fastpath.pread64": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=
=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.user_path_at_empty.vfs_fsta=
tat.SYSC_newstat.sys_newstat.system_call_fastpath": [=0A    0.04,=0A    0.0=
4,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles._=
_ctype_b_loc@plt": [=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05,=0A    =
0.05=0A  ],=0A  "perf-profile.cpu-cycles.strstr@plt": [=0A    0.04,=0A    0=
=2E04,=0A    0.04,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycl=
es.sys_openat": [=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.04,=0A    0.0=
3=0A  ],=0A  "perf-profile.cpu-cycles.__put_user_8.system_call_fastpath": [=
=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.04=0A  ],=0A  "per=
f-profile.cpu-cycles.locks_remove_posix.__close_fd.sys_close.system_call_fa=
stpath.close": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=
=0A  ],=0A  "perf-profile.cpu-cycles.simple_write_begin.generic_perform_wri=
te.__generic_file_write_iter.generic_file_write_iter.new_sync_write": [=0A =
   0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.vfs_getattr_nosec.vfs_getattr.vfs_fstatat.SYSC_newstat.sys=
_newstat": [=0A    0.04,=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.02=0A =
 ],=0A  "perf-profile.cpu-cycles.SYSC_kill.system_call_fastpath.kill": [=0A=
    0.04,=0A    0.05,=0A    0.05,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-p=
rofile.cpu-cycles.unlazy_walk.lookup_fast.path_lookupat.filename_lookup.use=
r_path_at_empty": [=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.03,=0A    0=
=2E04=0A  ],=0A  "perf-profile.cpu-cycles.copy_page_to_iter.generic_file_re=
ad_iter.new_sync_read.vfs_read.sys_pread64": [=0A    0.04,=0A    0.04,=0A  =
  0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.ima_file=
_check.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.04,=0A    0=
=2E04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycl=
es.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=0A    0.04=
,=0A    0.05,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.c=
pu-cycles.fsnotify_find_inode_mark.dnotify_flush.filp_close.__close_fd.sys_=
close": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=
=0A  "perf-profile.cpu-cycles.fsnotify.security_file_permission.rw_verify_a=
rea.vfs_read.sys_pread64": [=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.04=
,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.ima_get_action.ima_file_ch=
eck.do_last.path_openat.do_filp_open": [=0A    0.04,=0A    0.03,=0A    0.03=
,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.cancel_dirty_p=
age.truncate_inode_page.truncate_inode_pages_range.truncate_inode_pages_fin=
al.evict": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A =
 ],=0A  "perf-profile.cpu-cycles.__set_page_dirty_no_writeback.simple_write=
_end.generic_perform_write.__generic_file_write_iter.generic_file_write_ite=
r": [=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A =
 "perf-profile.cpu-cycles.__inode_permission.link_path_walk.path_openat.do_=
filp_open.do_sys_open": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=
=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.__fsnotify_parent.__fput.__=
__fput.task_work_run.do_notify_resume": [=0A    0.04,=0A    0.04,=0A    0.0=
3,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.vfs_unlink.do=
_unlinkat.sys_unlink.system_call_fastpath.unlink": [=0A    0.04,=0A    0.04=
,=0A    0.03,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.fi=
lename_lookup.user_path_at.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A    0=
=2E04,=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-prof=
ile.cpu-cycles.iov_iter_copy_from_user_atomic.generic_perform_write.__gener=
ic_file_write_iter.generic_file_write_iter.new_sync_write": [=0A    0.04,=
=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cp=
u-cycles.might_fault.SYSC_newstat.sys_newstat.system_call_fastpath.__xstat6=
4": [=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.03=0A  ],=0A =
 "perf-profile.cpu-cycles.memcpy.d_alloc.lookup_dcache.__lookup_hash.lookup=
_slow": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=
=0A  "perf-profile.cpu-cycles.generic_permission.inode_permission.link_path=
_walk.path_lookupat.filename_lookup": [=0A    0.04,=0A    0.04,=0A    0.04,=
=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.may_create.isra=
=2E38.selinux_inode_create.security_inode_create.vfs_create.do_last": [=0A =
   0.04,=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.avc_has_perm.may_create.selinux_inode_create.security_inod=
e_create.vfs_create": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0,=0A    =
0.04=0A  ],=0A  "perf-profile.cpu-cycles.__inode_permission.inode_permissio=
n.may_open.do_last.path_openat": [=0A    0.04,=0A    0.03,=0A    0.03,=0A  =
  0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.map_id_up.cp_new_sta=
t.SYSC_newstat.sys_newstat.system_call_fastpath": [=0A    0.04,=0A    0.03,=
=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.loc=
ks_remove_file.__fput.____fput.task_work_run.do_notify_resume": [=0A    0.0=
4,=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.=
cpu-cycles._raw_spin_lock_irqsave.pagevec_lru_move_fn.__lru_cache_add.lru_c=
ache_add.add_to_page_cache_lru": [=0A    0.04,=0A    0.04,=0A    0.04,=0A  =
  0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.delete_from_page_cac=
he.truncate_inode_page.truncate_inode_pages_range.truncate_inode_pages_fina=
l.evict": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  =
],=0A  "perf-profile.cpu-cycles._raw_spin_lock_irq.delete_from_page_cache.t=
runcate_inode_page.truncate_inode_pages_range.truncate_inode_pages_final": =
[=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A  "pe=
rf-profile.cpu-cycles.selinux_file_free_security.__fput.____fput.task_work_=
run.do_notify_resume": [=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.04,=0A=
    0.03=0A  ],=0A  "perf-profile.cpu-cycles.d_set_d_op.simple_lookup.looku=
p_real.__lookup_hash.lookup_slow": [=0A    0.04,=0A    0.03,=0A    0.03,=0A=
    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.sys_pread64.system=
_call_fastpath.pread64": [=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.03,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_page_lruvec.rele=
ase_pages.__pagevec_release.truncate_inode_pages_range.truncate_inode_pages=
_final": [=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.03,=0A    0.03=0A  ]=
,=0A  "perf-profile.cpu-cycles.dput.do_last.path_openat.do_filp_open.do_sys=
_open": [=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.03=0A  ],=
=0A  "perf-profile.cpu-cycles.iov_iter_fault_in_readable.__generic_file_wri=
te_iter.generic_file_write_iter.new_sync_write.vfs_write": [=0A    0.03,=0A=
    0.04,=0A    0.04,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-c=
ycles.lookup_page_cgroup.__mem_cgroup_commit_charge.mem_cgroup_charge_file.=
__add_to_page_cache_locked.add_to_page_cache_lru": [=0A    0.03,=0A    0.04=
,=0A    0.04,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.ch=
eck_kill_permission.kill_pid_info.SYSC_kill.sys_kill.system_call_fastpath":=
 [=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A  "p=
erf-profile.cpu-cycles.__list_add.iterate_dir.sys_getdents.system_call_fast=
path": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03=0A  ],=
=0A  "perf-profile.cpu-cycles.get_unused_fd_flags.do_sys_open.sys_open.syst=
em_call_fastpath.open64": [=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.put_page.delete_from_page_c=
ache.truncate_inode_page.truncate_inode_pages_range.truncate_inode_pages_fi=
nal": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=
=0A  "perf-profile.cpu-cycles.generic_file_write_iter.new_sync_write.vfs_wr=
ite.sys_pwrite64.system_call_fastpath": [=0A    0.03,=0A    0.04,=0A    0.0=
3,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_ch=
arge_file.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_pa=
ge.grab_cache_page_write_begin": [=0A    0.03,=0A    0.03,=0A    0.03,=0A  =
  0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.lockref_get_not_dead=
=2Eunlazy_walk.lookup_fast.path_lookupat.filename_lookup": [=0A    0.03,=0A=
    0.04,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-c=
ycles.mntget.do_dentry_open.finish_open.do_last.path_openat": [=0A    0.03,=
=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.user_path_at.SYSC_newstat.sys_newstat.system_call_fastpath.__xstat=
64": [=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.03=0A  ],=0A=
  "perf-profile.cpu-cycles.getname_flags.getname.do_sys_open.sys_open.syste=
m_call_fastpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0=
=2E03=0A  ],=0A  "perf-profile.cpu-cycles.legitimize_mnt.lookup_fast.path_l=
ookupat.filename_lookup.user_path_at_empty": [=0A    0.03,=0A    0.04,=0A  =
  0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.groups_s=
earch.generic_permission.__inode_permission.inode_permission.link_path_walk=
": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A  =
"perf-profile.cpu-cycles.filldir.iterate_dir.sys_getdents.system_call_fastp=
ath": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=
=0A  "perf-profile.cpu-cycles.fd_install.sys_openat.system_call_fastpath": =
[=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "pe=
rf-profile.cpu-cycles.__sb_start_write.vfs_write.sys_pwrite64.system_call_f=
astpath.__libc_pwrite": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=
=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.dput.__fput.____fput.task_w=
ork_run.do_notify_resume": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03=
,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.generic_permission.__inode=
_permission.inode_permission.may_open.do_last": [=0A    0.03,=0A    0.03,=
=0A    0.03,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__r=
adix_tree_lookup.find_get_entry.pagecache_get_page.grab_cache_page_write_be=
gin.simple_write_begin": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03,=
=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.group_send_sig_info.SYSC_ki=
ll.sys_kill.system_call_fastpath.kill": [=0A    0.03,=0A    0.04,=0A    0.0=
3,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.fsnotify.do_s=
ys_open.sys_openat.system_call_fastpath": [=0A    0.03,=0A    0.03,=0A    0=
=2E03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.selinux_t=
ask_kill.check_kill_permission.group_send_sig_info.kill_pid_info.SYSC_kill"=
: [=0A    0.03,=0A    0.05,=0A    0.05,=0A    0.03,=0A    0.04=0A  ],=0A  "=
perf-profile.cpu-cycles.pagecache_get_page.new_sync_read.vfs_read.sys_pread=
64.system_call_fastpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__set_page_dirty_no_writeba=
ck.set_page_dirty.simple_write_end.generic_perform_write.__generic_file_wri=
te_iter": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  =
],=0A  "perf-profile.cpu-cycles.inode_has_perm.isra.32.selinux_inode_getatt=
r.security_inode_getattr.vfs_getattr.vfs_fstat": [=0A    0.03,=0A    0.03,=
=0A    0.03,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles._ra=
w_spin_unlock.__dentry_kill.dput.dcache_dir_close.__fput": [=0A    0.03,=0A=
    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-c=
ycles.process_measurement.do_last.path_openat.do_filp_open.do_sys_open": [=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "per=
f-profile.cpu-cycles.get_unused_fd_flags.sys_open.system_call_fastpath.open=
64": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.04=0A  ],=0A=
  "perf-profile.cpu-cycles.ima_match_policy.ima_get_action.process_measurem=
ent.ima_file_check.do_last": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.=
03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_alloc_secur=
ity.security_file_alloc.get_empty_filp.path_openat.do_filp_open": [=0A    0=
=2E03,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-prof=
ile.cpu-cycles.get_pfnblock_flags_mask.free_hot_cold_page.free_hot_cold_pag=
e_list.release_pages.__pagevec_release": [=0A    0.03,=0A    0.03,=0A    0.=
03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.security_fil=
e_permission.sys_getdents.system_call_fastpath": [=0A    0.03,=0A    0.04,=
=0A    0.03,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.mut=
ex_unlock.path_lookupat.filename_lookup.user_path_at_empty.user_path_at": [=
=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03=0A  ],=0A  "per=
f-profile.cpu-cycles.__inc_zone_state.zone_statistics.get_page_from_freelis=
t.__alloc_pages_nodemask.alloc_pages_current": [=0A    0.03,=0A    0.04,=0A=
    0.03,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.unlock=
_page.truncate_inode_pages_range.truncate_inode_pages_final.evict.iput": [=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "per=
f-profile.cpu-cycles.mark_page_accessed.pagecache_get_page.grab_cache_page_=
write_begin.simple_write_begin.generic_perform_write": [=0A    0.03,=0A    =
0.04,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycle=
s.__list_add.inode_sb_list_add.new_inode.ramfs_get_inode.ramfs_mknod": [=0A=
    0.03,=0A    0.03,=0A    0,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-prof=
ile.cpu-cycles.kmem_cache_alloc.__d_alloc.d_alloc.lookup_dcache.do_last": [=
=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.03=0A  ],=0A  "per=
f-profile.cpu-cycles.inode_permission.do_last.path_openat.do_filp_open.do_s=
ys_open": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  =
],=0A  "perf-profile.cpu-cycles.__fsnotify_parent.iterate_dir.sys_getdents.=
system_call_fastpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A=
    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__radix_tree_preload.radix_tre=
e_maybe_preload.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_=
get_page": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03,=0A    0.03=0A =
 ],=0A  "perf-profile.cpu-cycles.selinux_d_instantiate.d_instantiate.simple=
_lookup.lookup_real.__lookup_hash": [=0A    0.03,=0A    0.03,=0A    0.02,=
=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__sb_start_writ=
e.mnt_want_write.do_last.path_openat.do_filp_open": [=0A    0.03,=0A    0.0=
3,=0A    0.03,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles._=
raw_spin_trylock.dput.dcache_dir_close.__fput.____fput": [=0A    0.03,=0A  =
  0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cyc=
les.file_ra_state_init.do_dentry_open.finish_open.do_last.path_openat": [=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "per=
f-profile.cpu-cycles.lockref_put_or_lock.dput.terminate_walk.path_lookupat.=
filename_lookup": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0=
=2E03=0A  ],=0A  "perf-profile.cpu-cycles.pid_vnr.sys_kill.system_call_fast=
path.kill": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A=
  ],=0A  "perf-profile.cpu-cycles.__fsnotify_parent.do_dentry_open.finish_o=
pen.do_last.path_openat": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.04,=
=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.map_id_up.from_kuid_munged.=
SYSC_kill.sys_kill.system_call_fastpath": [=0A    0.03,=0A    0.03,=0A    0=
=2E03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.int_check=
_syscall_exit_work.close": [=0A    0.03,=0A    0.01,=0A    0.01,=0A    0.02=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.readdir@plt": [=0A    0.03=
,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.c=
pu-cycles.opendir": [=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.03,=0A   =
 0.02=0A  ],=0A  "perf-profile.cpu-cycles.__libc_pwrite": [=0A    0.03,=0A =
   0.04,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cy=
cles.gettimeofday@plt": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.int_with_check.close": [=0A=
    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-p=
rofile.cpu-cycles.sysret_signal.close": [=0A    0.03,=0A    0.02,=0A    0.0=
2,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.generic_permi=
ssion.inode_permission.link_path_walk.path_openat.do_filp_open": [=0A    0.=
03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.current_kernel_time.current_fs_time.touch_atime.iterate_dir.s=
ys_getdents": [=0A    0.03,=0A    0.05,=0A    0.03,=0A    0.04,=0A    0.03=
=0A  ],=0A  "perf-profile.cpu-cycles.complete_walk.do_last.path_openat.do_f=
ilp_open.do_sys_open": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A=
    0.03=0A  ],=0A  "perf-profile.cpu-cycles.putname.user_path_at.vfs_fstat=
at.SYSC_newstat.sys_newstat": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0=
=2E03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.simple_getattr.vfs_ge=
tattr_nosec.vfs_getattr.vfs_fstatat.SYSC_newstat": [=0A    0.03,=0A    0.03=
,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__=
fsnotify_parent.security_file_permission.iterate_dir.sys_getdents.system_ca=
ll_fastpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=
=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.kmem_cache_alloc.getname=
_flags.user_path_at_empty.user_path_at": [=0A    0.03,=0A    0.03,=0A    0.=
03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.link_path_wa=
lk.path_lookupat.filename_lookup.user_path_parent.SYSC_renameat2": [=0A    =
0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profi=
le.cpu-cycles.simple_getattr.vfs_getattr_nosec.vfs_getattr.vfs_fstat.SYSC_n=
ewfstat": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03=0A  =
],=0A  "perf-profile.cpu-cycles.__slab_free.kmem_cache_free.radix_tree_node=
_rcu_free.rcu_nocb_kthread.kthread": [=0A    0.03,=0A    0.03,=0A    0.02,=
=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_lock_=
irq.clear_inode.evict.iput.do_unlinkat": [=0A    0.03,=0A    0.03,=0A    0.=
03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__fdget.syst=
em_call_fastpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    =
0.04=0A  ],=0A  "perf-profile.cpu-cycles.iput.do_unlinkat.sys_unlink.system=
_call_fastpath.unlink": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.04,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.dnotify_flush.__close_fd.sy=
s_close.system_call_fastpath.close": [=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.mntput_no_expir=
e.mntput.__fput.____fput.task_work_run": [=0A    0.03,=0A    0.03,=0A    0.=
03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__d_lookup.d=
_lookup.lookup_dcache.__lookup_hash.lookup_slow": [=0A    0.03,=0A    0.03,=
=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.rcu=
_check_callbacks.update_process_times.tick_sched_handle.tick_sched_timer.__=
run_hrtimer": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=
=0A  ],=0A  "perf-profile.cpu-cycles.strncpy_from_user.user_path_at_empty.u=
ser_path_at.vfs_fstatat.SYSC_newstat": [=0A    0.03,=0A    0.03,=0A    0.03=
,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.truncate_inode=
_pages_final.evict.iput.do_unlinkat.sys_unlink": [=0A    0.03,=0A    0.03,=
=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.tru=
ncate_inode_page.truncate_inode_pages_range.truncate_inode_pages_final.evic=
t.iput": [=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.04=0A  ]=
,=0A  "perf-profile.cpu-cycles.statfs_by_dentry.vfs_statfs.user_statfs.SYSC=
_statfs.sys_statfs": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.04,=0A  =
  0.03=0A  ],=0A  "perf-profile.cpu-cycles.__sb_end_write.vfs_write.sys_pwr=
ite64.system_call_fastpath.__libc_pwrite": [=0A    0.03,=0A    0.02,=0A    =
0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.dcache_dir=
_close.____fput.task_work_run.do_notify_resume.int_signal": [=0A    0.03,=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.security_file_open.finish_open.do_last.path_openat.do_filp_open": =
[=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "pe=
rf-profile.cpu-cycles.d_delete.vfs_unlink.do_unlinkat.sys_unlink.system_cal=
l_fastpath": [=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03=
=0A  ],=0A  "perf-profile.cpu-cycles.__srcu_read_lock.vfs_write.sys_pwrite6=
4.system_call_fastpath.__libc_pwrite": [=0A    0.03,=0A    0.03,=0A    0.03=
,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.group_send_sig=
_info.kill_pid_info.SYSC_kill.sys_kill.system_call_fastpath": [=0A    0.03,=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.d_instantiate.simple_lookup.lookup_real.__lookup_hash.lookup_slow"=
: [=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "=
perf-profile.cpu-cycles.do_notify_resume.close": [=0A    0.03,=0A    0.02,=
=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.do_=
filp_open.do_sys_open.sys_open.system_call_fastpath.open64": [=0A    0.03,=
=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.__fsnotify_parent.security_file_open.do_dentry_open.finish_open.do=
_last": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=
=0A  "perf-profile.cpu-cycles.kfree.selinux_file_free_security.security_fil=
e_free.put_filp.path_openat": [=0A    0.03,=0A    0.03,=0A    0.02,=0A    0=
=2E03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.lookup_slow.filename_=
lookup.user_path_at_empty.user_path_at.vfs_fstatat": [=0A    0.03,=0A    0.=
02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.=
mntget.path_get.do_dentry_open.finish_open.do_last": [=0A    0.03,=0A    0.=
03,=0A    0.03,=0A    0.02,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.=
lockref_put_or_lock.dput.path_lookupat.filename_lookup.user_path_at_empty":=
 [=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.03=0A  ],=0A  "p=
erf-profile.cpu-cycles.release_pages.pagevec_lru_move_fn.__lru_cache_add.lr=
u_cache_add.add_to_page_cache_lru": [=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__list_add.d_al=
loc.dcache_dir_open.do_dentry_open.finish_open": [=0A    0.03,=0A    0.03,=
=0A    0.02,=0A    0.02,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.fil=
e_update_time.__generic_file_write_iter.generic_file_write_iter.new_sync_wr=
ite.vfs_write": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.0=
3=0A  ],=0A  "perf-profile.cpu-cycles.__d_alloc.d_alloc.lookup_dcache.do_la=
st.path_openat": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.=
03=0A  ],=0A  "perf-profile.cpu-cycles.find_vpid.sys_kill.system_call_fastp=
ath.kill": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.04=0A =
 ],=0A  "perf-profile.cpu-cycles._raw_spin_unlock.__dentry_kill.dput.termin=
ate_walk.path_lookupat": [=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.02,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__sb_end_write.mnt_drop_wri=
te.do_last.path_openat.do_filp_open": [=0A    0.03,=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__dec_zone_stat=
e.__dec_zone_page_state.__delete_from_page_cache.delete_from_page_cache.tru=
ncate_inode_page": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02,=0A    =
0.03=0A  ],=0A  "perf-profile.cpu-cycles.fput.__close_fd.sys_close.system_c=
all_fastpath.close": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A  =
  0.03=0A  ],=0A  "perf-profile.cpu-cycles.dput.dcache_dir_close.__fput.___=
_fput.task_work_run": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02,=0A =
   0.03=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_alloc_security.se=
curity_inode_alloc.inode_init_always.alloc_inode.new_inode_pseudo": [=0A   =
 0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.dput.terminate_walk.do_last.path_openat.do_filp_open": [=0A =
   0.03,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.selinux_sb_statfs.security_sb_statfs.statfs_by_dentry.vfs_=
statfs.user_statfs": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A  =
  0.04=0A  ],=0A  "perf-profile.cpu-cycles.lookup_page_cgroup.__mem_cgroup_=
uncharge_common.mem_cgroup_uncharge_cache_page.delete_from_page_cache.trunc=
ate_inode_page": [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.=
02=0A  ],=0A  "perf-profile.cpu-cycles.__radix_tree_delete_node.__delete_fr=
om_page_cache.delete_from_page_cache.truncate_inode_page.truncate_inode_pag=
es_range": [=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.02=0A =
 ],=0A  "perf-profile.cpu-cycles.do_dentry_open.do_last.path_openat.do_filp=
_open.do_sys_open": [=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.finish=
_open.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.02,=0A    0.=
02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.=
d_lookup.lookup_dcache.do_last.path_openat.do_filp_open": [=0A    0.02,=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cy=
cles.kick_process.task_work_add.fput.filp_close.__close_fd": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.sys_pread64.pread64": [=0A    0.02,=0A    0.02,=0A    0.03,=0A    =
0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.do_unlinkat.sys_unlink=
=2Esystem_call_fastpath.unlink": [=0A    0.02,=0A    0.02,=0A    0.03,=0A  =
  0.02,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.dput.terminate_walk.=
path_lookupat.filename_lookup.user_path_at_empty": [=0A    0.02,=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.ma=
p_id_up.SYSC_kill.sys_kill.system_call_fastpath.kill": [=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycle=
s.__might_sleep.kmem_cache_alloc.getname_flags.getname.do_sys_open": [=0A  =
  0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.03=0A  ],=0A  "perf-pro=
file.cpu-cycles.bit_waitqueue.inode_wait_for_writeback.evict.iput.do_unlink=
at": [=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A=
  "perf-profile.cpu-cycles.inode_doinit_with_dentry.selinux_d_instantiate.s=
ecurity_d_instantiate.d_instantiate.ramfs_mknod": [=0A    0.02,=0A    0.03,=
=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.mnt=
put.vfs_fstatat.SYSC_newstat.sys_newstat.system_call_fastpath": [=0A    0.0=
2,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.=
cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_curren=
t.new_slab.__slab_alloc": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.simple_lookup.lookup_real._=
_lookup_hash.lookup_slow.path_lookupat": [=0A    0.02,=0A    0.03,=0A    0.=
03,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.SYSC_newstat=
=2Esys_newstat.system_call_fastpath.__xstat64": [=0A    0.02,=0A    0.02,=
=0A    0.03,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.com=
plete_walk.path_lookupat.filename_lookup.user_path_at_empty.user_path_at": =
[=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "pe=
rf-profile.cpu-cycles.page_mapping.simple_write_end.generic_perform_write._=
_generic_file_write_iter.generic_file_write_iter": [=0A    0.02,=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__=
might_sleep.kmem_cache_alloc.get_empty_filp.path_openat.do_filp_open": [=0A=
    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-p=
rofile.cpu-cycles.iov_iter_copy_from_user_atomic.__generic_file_write_iter.=
generic_file_write_iter.new_sync_write.vfs_write": [=0A    0.02,=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.rw=
_verify_area.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=
=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.03=0A  ],=0A  "per=
f-profile.cpu-cycles.security_file_permission.rw_verify_area.vfs_read.sys_p=
read64.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0=
=2E02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.list_del.dput.dcache_=
dir_close.__fput.____fput": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.0=
2,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__d_instantiate.simple_lo=
okup.lookup_real.__lookup_hash.lookup_slow": [=0A    0.02,=0A    0.02,=0A  =
  0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.inode_ha=
s_perm.isra.32.security_inode_getattr.vfs_getattr.vfs_fstatat.SYSC_newstat"=
: [=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "=
perf-profile.cpu-cycles.d_instantiate.lookup_real.__lookup_hash.lookup_slow=
=2Epath_lookupat": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    =
0.02=0A  ],=0A  "perf-profile.cpu-cycles.lookup_fast.link_path_walk.path_lo=
okupat.filename_lookup.user_path_parent": [=0A    0.02,=0A    0.02,=0A    0=
=2E02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin=
_lock_irqsave.pagevec_lru_move_fn.lru_add_drain_cpu.__pagevec_release.trunc=
ate_inode_pages_range": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.path_get.finish_open.do_las=
t.path_openat.do_filp_open": [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.=
02,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.file_remove_suid.__gener=
ic_file_write_iter.generic_file_write_iter.new_sync_write.vfs_write": [=0A =
   0.02,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.cp_new_stat.sys_newstat.system_call_fastpath.__xstat64": [=
=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.03=0A  ],=0A  "per=
f-profile.cpu-cycles.radix_tree_lookup_slot.pagecache_get_page.generic_file=
_read_iter.new_sync_read.vfs_read": [=0A    0.02,=0A    0.03,=0A    0.02,=
=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mutex_unlock.se=
linux_d_instantiate.security_d_instantiate.d_instantiate.ramfs_mknod": [=0A=
    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-p=
rofile.cpu-cycles.wait_for_stable_page.grab_cache_page_write_begin.simple_w=
rite_begin.generic_perform_write.__generic_file_write_iter": [=0A    0.02,=
=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.kfree.security_file_free.__fput.____fput.task_work_run": [=0A    0=
=2E02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.security_inode_getattr.vfs_fstat.SYSC_newfstat.sys_newfstat.=
system_call_fastpath": [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02,=0A=
    0.02=0A  ],=0A  "perf-profile.cpu-cycles.path_lookupat.user_path_at_emp=
ty.user_path_at.vfs_fstatat.SYSC_newstat": [=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__page_cac=
he_alloc.pagecache_get_page.grab_cache_page_write_begin.simple_write_begin.=
generic_perform_write": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mutex_init.path_openat.do=
_filp_open.do_sys_open.sys_openat": [=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_pe=
rmission.rw_verify_area.vfs_read.sys_pread64.system_call_fastpath": [=0A   =
 0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.page_mapping.grab_cache_page_write_begin.simple_write_begin.=
generic_perform_write.__generic_file_write_iter": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mnt=
put_no_expire.mntput.terminate_walk.do_last.path_openat": [=0A    0.02,=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cy=
cles.d_flags_for_inode.d_instantiate.simple_lookup.lookup_real.__lookup_has=
h": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A =
 "perf-profile.cpu-cycles.do_sys_open.system_call_fastpath": [=0A    0.02,=
=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.get=
name_flags.user_path_at.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.c=
pu-cycles.__mnt_want_write.touch_atime.generic_file_read_iter.new_sync_read=
=2Evfs_read": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.__pagevec_lru_add_fn.pagevec_lru_move_=
fn.lru_add_drain_cpu.__pagevec_release.truncate_inode_pages_range": [=0A   =
 0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.mem_cgroup_try_charge_mm.mem_cgroup_charge_file.__add_to_pag=
e_cache_locked.add_to_page_cache_lru.pagecache_get_page": [=0A    0.02,=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cy=
cles.from_kuid_munged.SYSC_newstat.sys_newstat.system_call_fastpath.__xstat=
64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A=
  "perf-profile.cpu-cycles.__percpu_counter_add.path_openat.do_filp_open.do=
_sys_open.sys_openat": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A=
    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mutex_unlock.new_sync_write.vf=
s_write.sys_pwrite64.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A   =
 0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.pagecache=
_get_page.simple_write_begin.generic_perform_write.__generic_file_write_ite=
r.generic_file_write_iter": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.0=
2,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.from_kgid_munged.SYSC_new=
stat.sys_newstat.system_call_fastpath.__xstat64": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.gra=
b_cache_page_write_begin.simple_write_begin.generic_perform_write.__generic=
_file_write_iter.generic_file_write_iter": [=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.simple_wri=
te_begin.__generic_file_write_iter.generic_file_write_iter.new_sync_write.v=
fs_write": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A =
 ],=0A  "perf-profile.cpu-cycles.__errno_location": [=0A    0.02,=0A    0.0=
1,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.s=
tatvfs": [=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.02=0A  ]=
,=0A  "perf-profile.cpu-cycles.unlink": [=0A    0.02,=0A    0.02,=0A    0.0=
2,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.retint_swapgs=
=2Eclose": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A =
 ],=0A  "perf-profile.cpu-cycles.__uflow": [=0A    0.02,=0A    0.01,=0A    =
0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.balance_di=
rty_pages_ratelimited.__generic_file_write_iter.generic_file_write_iter.new=
_sync_write.vfs_write": [=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.memcpy@plt": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.cap_inode_need_killpriv.file_remove_suid.__generic_file_write_iter=
=2Egeneric_file_write_iter.new_sync_write": [=0A    0.02,=0A    0.03,=0A   =
 0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.strcasecm=
p@plt": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.int_restore_rest.close": [=0A    0.02,=0A    =
0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycle=
s.generic_fillattr.vfs_getattr_nosec.vfs_getattr.vfs_fstatat.SYSC_newstat":=
 [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "p=
erf-profile.cpu-cycles.__slab_alloc.kmem_cache_alloc.__d_alloc.d_alloc.look=
up_dcache": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A=
  ],=0A  "perf-profile.cpu-cycles.__inc_zone_state.__inc_zone_page_state.__=
add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page": [=0A   =
 0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.d_alloc.lookup_dcache.__lookup_hash.lookup_slow.path_lookupa=
t": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A =
 "perf-profile.cpu-cycles.follow_managed.lookup_slow.path_lookupat.filename=
_lookup.user_path_at_empty": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.=
02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.dput.path_lookupat.filen=
ame_lookup.user_path_at_empty.user_path_at": [=0A    0.02,=0A    0.02,=0A  =
  0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.notify_c=
hange.utimes_common.do_utimes.sys_utime.system_call_fastpath": [=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.c=
pu-cycles.__srcu_read_unlock.fsnotify.vfs_write.sys_pwrite64.system_call_fa=
stpath": [=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.03=0A  ]=
,=0A  "perf-profile.cpu-cycles._raw_spin_trylock.dput.terminate_walk.path_l=
ookupat.filename_lookup": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.from_kuid_munged.sys_kill.s=
ystem_call_fastpath.kill": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.kill_pid_info.sys_kill.sys=
tem_call_fastpath.kill": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.current_kernel_time.current=
_fs_time.touch_atime.generic_file_read_iter.new_sync_read": [=0A    0.02,=
=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.__fd_install.fd_install.do_sys_open.sys_openat.system_call_fastpat=
h": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A =
 "perf-profile.cpu-cycles.ima_file_check.path_openat.do_filp_open.do_sys_op=
en.sys_openat": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.0=
2=0A  ],=0A  "perf-profile.cpu-cycles.__list_del_entry.list_del.__dentry_ki=
ll.dput.dcache_dir_close": [=0A    0.02,=0A    0.02,=0A    0,=0A    0,=0A  =
  0.02=0A  ],=0A  "perf-profile.cpu-cycles.vfs_rename.SYSC_renameat2.sys_re=
name.system_call_fastpath.rename": [=0A    0.02,=0A    0.02,=0A    0.02,=0A=
    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.find_next_zero_bit=
=2E__alloc_fd.get_unused_fd_flags.do_sys_open.sys_openat": [=0A    0.02,=0A=
    0.03,=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-c=
ycles.sys_open.open64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mutex_init.get_empty_filp=
=2Epath_openat.do_filp_open.do_sys_open": [=0A    0.02,=0A    0.02,=0A    0=
=2E02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.avc_polic=
y_seqno.security_file_permission.iterate_dir.sys_getdents.system_call_fastp=
ath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.unlazy_walk.path_lookupat.filename_lookup.use=
r_path_at_empty.user_path_at": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.restore_args.close": [=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.sys_newfstat.__fxstat64": [=0A    0.02,=0A    0.02,=0A=
    0.02,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.sys_pw=
rite64.__libc_pwrite": [=0A    0.02,=0A    0,=0A    0,=0A    0.02,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles.security_inode_permission.__inode_pe=
rmission.inode_permission.link_path_walk.path_lookupat": [=0A    0.02,=0A  =
  0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cyc=
les.do_filp_open.sys_openat.system_call_fastpath": [=0A    0.02,=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.op=
en_check_o_direct.path_openat.do_filp_open.do_sys_open.sys_openat": [=0A   =
 0.02,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.inode_has_perm.isra.32.security_file_open.do_dentry_open.fin=
ish_open.do_last": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    =
0.02=0A  ],=0A  "perf-profile.cpu-cycles.generic_file_read_iter.new_sync_re=
ad.vfs_read.sys_read.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A   =
 0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin=
_trylock.terminate_walk.path_lookupat.filename_lookup.user_path_at_empty": =
[=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "pe=
rf-profile.cpu-cycles.filp_close.sys_close.system_call_fastpath.close": [=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.map_id_up.cp_new_stat.SYSC_newfstat.sys_newfstat.syste=
m_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0=
=2E02=0A  ],=0A  "perf-profile.cpu-cycles._copy_to_user.SYSC_newstat.sys_ne=
wstat.system_call_fastpath.__xstat64": [=0A    0.02,=0A    0.02,=0A    0.02=
,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mnt_want_wri=
te.mnt_want_write.utimes_common.do_utimes.sys_utime": [=0A    0.02,=0A    0=
=2E02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycl=
es.security_d_instantiate.simple_lookup.lookup_real.__lookup_hash.lookup_sl=
ow": [=0A    0.02,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "per=
f-profile.cpu-cycles.__might_sleep.kmem_cache_alloc.__d_alloc.d_alloc.dcach=
e_dir_open": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.__rmqueue.__alloc_pages_nodemask.alloc=
_pages_current.__page_cache_alloc.pagecache_get_page": [=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycle=
s.current_fs_time.touch_atime.iterate_dir.sys_getdents.system_call_fastpath=
": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  =
"perf-profile.cpu-cycles.pagevec_lru_move_fn.lru_add_drain_cpu.__pagevec_re=
lease.truncate_inode_pages_range.truncate_inode_pages_final": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.sys_unlink.unlink": [=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.selinux_file_alloc_security.get_empty_filp.path_openat.do_fi=
lp_open.do_sys_open": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A =
   0.02=0A  ],=0A  "perf-profile.cpu-cycles.current_has_perm.security_task_=
kill.check_kill_permission.group_send_sig_info.kill_pid_info": [=0A    0.02=
,=0A    0.03,=0A    0.05,=0A    0.02,=0A    0.03=0A  ],=0A  "perf-profile.c=
pu-cycles.strncpy_from_user.getname.do_sys_open.sys_openat.system_call_fast=
path": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.mark_page_accessed.generic_file_read_iter.new=
_sync_read.vfs_read.sys_pread64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A =
   0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.lru_add_drain_cpu._=
_pagevec_release.truncate_inode_pages_range.truncate_inode_pages_final.evic=
t": [=0A    0.02,=0A    0.02,=0A    0,=0A    0.02,=0A    0.02=0A  ],=0A  "p=
erf-profile.cpu-cycles.__call_rcu_nocb_enqueue.call_rcu_sched.selinux_inode=
_free_security.security_inode_free.__destroy_inode": [=0A    0.02,=0A    0.=
02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.=
____fput.do_notify_resume.int_signal.close": [=0A    0.02,=0A    0.02,=0A  =
  0,=0A    0,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.may_open.path_=
openat.do_filp_open.do_sys_open.sys_openat": [=0A    0.02,=0A    0.02,=0A  =
  0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__percpu=
_counter_add.____fput.task_work_run.do_notify_resume.int_signal": [=0A    0=
=2E02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.avc_policy_seqno.security_file_open.do_dentry_open.finish_op=
en.do_last": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_page_lruvec.pagevec_lru_mov=
e_fn.lru_add_drain_cpu.__pagevec_release.truncate_inode_pages_range": [=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.selinux_task_kill.security_task_kill.check_kill_permission=
=2Egroup_send_sig_info.kill_pid_info": [=0A    0.02,=0A    0.01,=0A    0.01=
,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mod_zone_pag=
e_state.release_pages.__pagevec_release.truncate_inode_pages_range.truncate=
_inode_pages_final": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A  =
  0.02=0A  ],=0A  "perf-profile.cpu-cycles.vfs_fstat.sys_newfstat.system_ca=
ll_fastpath.__fxstat64": [=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.might_fault.filldir.dcache_=
readdir.iterate_dir.sys_getdents": [=0A    0.02,=0A    0.02,=0A    0.02,=0A=
    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.ima_file_free.____=
fput.task_work_run.do_notify_resume.int_signal": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.loc=
kref_get.do_dentry_open.finish_open.do_last.path_openat": [=0A    0.02,=0A =
   0.01,=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cy=
cles.mem_cgroup_uncharge_end.truncate_inode_pages_range.truncate_inode_page=
s_final.evict.iput": [=0A    0.02,=0A    0,=0A    0.02,=0A    0,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.iov_iter_init.vfs_read.sys_pread64.sys=
tem_call_fastpath.pread64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.0=
2,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.radix_tree_lookup_slot.pa=
gecache_get_page.grab_cache_page_write_begin.simple_write_begin.generic_per=
form_write": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.res_counter_uncharge_until.res_counter=
_uncharge.mem_cgroup_uncharge_end.truncate_inode_pages_range.truncate_inode=
_pages_final": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.__d_instantiate.d_instantiate.simple_l=
ookup.lookup_real.do_last": [=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.0=
1,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.find_next_zero_bit.__allo=
c_fd.get_unused_fd_flags.do_sys_open.sys_open": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.new=
_slab.__slab_alloc.kmem_cache_alloc.__d_alloc.d_alloc": [=0A    0.02,=0A   =
 0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycl=
es.__fsnotify_parent.security_file_permission.rw_verify_area.vfs_read.sys_p=
read64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ]=
,=0A  "perf-profile.cpu-cycles.handle_dots.path_lookupat.filename_lookup.us=
er_path_at_empty.user_path_at": [=0A    0.02,=0A    0.02,=0A    0.02,=0A   =
 0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.generic_file_read_ite=
r.vfs_read.sys_pread64.system_call_fastpath.pread64": [=0A    0.02,=0A    0=
=2E01,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycl=
es.lookup_dcache.__lookup_hash.lookup_slow.path_lookupat.filename_lookup": =
[=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "pe=
rf-profile.cpu-cycles.mnt_drop_write.path_openat.do_filp_open.do_sys_open.s=
ys_open": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles.lookup_fast.path_openat.do_filp_open.do_sys=
_open.sys_openat": [=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__might=
_sleep.might_fault.sys_getdents.system_call_fastpath": [=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycle=
s.__d_drop.dput.terminate_walk.do_last.path_openat": [=0A    0.02,=0A    0.=
02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.=
new_sync_write.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": =
[=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "pe=
rf-profile.cpu-cycles.__d_drop.dput.dcache_dir_close.__fput.____fput": [=0A=
    0.02,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.run_timer_softirq.__do_softirq.irq_exit.smp_apic_timer_in=
terrupt.apic_timer_interrupt": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__d_free.__dentry_kill=
=2Edput.dcache_dir_close.__fput": [=0A    0.02,=0A    0.02,=0A    0.02,=0A =
   0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.get_mem_cgroup_from=
_mm.mem_cgroup_charge_file.__add_to_page_cache_locked.add_to_page_cache_lru=
=2Epagecache_get_page": [=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mntput_no_expire.terminate_=
walk.do_last.path_openat.do_filp_open": [=0A    0.02,=0A    0.02,=0A    0.0=
2,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__d_drop.dput=
=2Edo_unlinkat.sys_unlink.system_call_fastpath": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.fd_=
install.sys_open.system_call_fastpath.open64": [=0A    0.02,=0A    0.01,=0A=
    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mntput=
=2E____fput.task_work_run.do_notify_resume.int_signal": [=0A    0.02,=0A   =
 0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycl=
es.evict.iput.do_unlinkat.sys_unlink.system_call_fastpath": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.inode_permission.link_path_walk.path_lookupat.filename_lookup.user=
_path_at_empty": [=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.=
02=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.kmem_cache_alloc.__d_a=
lloc.d_alloc.lookup_dcache": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.=
02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.free_hot_cold_page_list.=
release_pages.__pagevec_release.truncate_inode_pages_range.truncate_inode_p=
ages_final": [=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_trylock.dcache_dir_close.__f=
put.____fput.task_work_run": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.=
02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mntput.path_lookupat.fil=
ename_lookup.user_path_at_empty.user_path_at": [=0A    0.02,=0A    0.01,=0A=
    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.pid_ta=
sk.kill_pid_info.SYSC_kill.sys_kill.system_call_fastpath": [=0A    0.02,=0A=
    0.01,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycl=
es.iterate_dir.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mntput_no_expir=
e.mntput.path_put.vfs_fstatat.SYSC_newstat": [=0A    0.02,=0A    0.02,=0A  =
  0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.fsnotify=
=2Edo_sys_open.sys_open.system_call_fastpath.open64": [=0A    0.02,=0A    0=
=2E02,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycl=
es.__d_lookup.d_lookup.lookup_dcache.do_last.path_openat": [=0A    0.02,=0A=
    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-c=
ycles.selinux_inode_getattr.security_inode_getattr.vfs_getattr.vfs_fstatat.=
SYSC_newstat": [=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.lookup_real.__lookup_hash.lookup_slow.=
path_lookupat.filename_lookup": [=0A    0.02,=0A    0.01,=0A    0.01,=0A   =
 0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_getattr=
=2Evfs_getattr.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A    0.02,=0A    0=
=2E01,=0A    0.01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycl=
es.__fsnotify_parent.do_sys_open.sys_openat.system_call_fastpath": [=0A    =
0.02,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profi=
le.cpu-cycles._raw_spin_unlock.dput.dcache_dir_close.__fput.____fput": [=0A=
    0.02=0A  ],=0A  "perf-profile.cpu-cycles.getname.sys_openat.system_call=
_fastpath": [=0A    0.02,=0A    0.02,=0A    0,=0A    0,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.map_id_down.inode_init_always.alloc_inode.new=
_inode_pseudo.new_inode": [=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.memcpy.d_alloc.lookup_dcach=
e.do_last.path_openat": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_alloc_securit=
y.inode_init_always.alloc_inode.new_inode_pseudo.new_inode": [=0A    0.01,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.__dec_zone_state.__delete_from_page_cache.delete_from_page_cache.t=
runcate_inode_page.truncate_inode_pages_range": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mem=
_cgroup_update_lru_size.release_pages.__pagevec_release.truncate_inode_page=
s_range.truncate_inode_pages_final": [=0A    0.01,=0A    0.02,=0A    0.02,=
=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.alloc_inode.new=
_inode_pseudo.new_inode.ramfs_get_inode.ramfs_mknod": [=0A    0.01,=0A    0=
=2E01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycl=
es.zone_statistics.get_page_from_freelist.__alloc_pages_nodemask.alloc_page=
s_current.__page_cache_alloc": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    =
0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_charge_stat=
istics.isra.20.__mem_cgroup_commit_charge.mem_cgroup_charge_file.__add_to_p=
age_cache_locked.add_to_page_cache_lru": [=0A    0.01,=0A    0.01,=0A    0.=
01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.d_alloc.dcac=
he_dir_open.do_dentry_open.finish_open.do_last": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__z=
one_watermark_ok.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_=
current.__page_cache_alloc": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.=
01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.kmem_cache_alloc.getname=
_flags.user_path_at_empty.user_path_at.user_statfs": [=0A    0.01,=0A    0.=
02,=0A    0.01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.=
find_vpid.SYSC_kill.sys_kill.system_call_fastpath.kill": [=0A    0.01,=0A  =
  0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cyc=
les.inode_permission.link_path_walk.path_openat.do_filp_open.do_sys_open": =
[=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "pe=
rf-profile.cpu-cycles.mutex_lock.generic_file_write_iter.new_sync_write.vfs=
_write.sys_pwrite64": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01,=0A =
   0.01=0A  ],=0A  "perf-profile.cpu-cycles.policy_zonelist.alloc_pages_cur=
rent.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_begin": [=
=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.try_module_get.do_dentry_open.finish_open.do_last.path=
_openat": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles.__mod_zone_page_state.get_page_from_freelis=
t.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc": [=0A    0=
=2E01,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.pid_task.SYSC_kill.sys_kill.system_call_fastpath.kill": [=0A=
    0.01,=0A    0,=0A    0,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.dput.path_put.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A    =
0.01,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profi=
le.cpu-cycles.__call_rcu_nocb_enqueue.call_rcu_sched.__fput.____fput.task_w=
ork_run": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles.always_delete_dentry.terminate_walk.path_lo=
okupat.filename_lookup.user_path_at_empty": [=0A    0.01,=0A    0.01,=0A   =
 0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.security_=
inode_permission.__inode_permission.inode_permission.link_path_walk.path_op=
enat": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.security_file_free.____fput.task_work_run.do_=
notify_resume.int_signal": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.may_link.isra.33.selinux_i=
node_unlink.security_inode_unlink.vfs_unlink.do_unlinkat": [=0A    0.01,=0A=
    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-c=
ycles.locks_remove_file.____fput.task_work_run.do_notify_resume.int_signal"=
: [=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "=
perf-profile.cpu-cycles.__d_free.dentry_free.__dentry_kill.dput.dcache_dir_=
close": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.d_lookup.lookup_dcache.__lookup_hash.do_unlin=
kat.sys_unlink": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles.inode_has_perm.isra.32.selinux_file_=
open.security_file_open.do_dentry_open.finish_open": [=0A    0.01,=0A    0.=
01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.policy_zonel=
ist.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_begin.simpl=
e_write_begin": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles.workingset_activation.mark_page_acces=
sed.pagecache_get_page.grab_cache_page_write_begin.simple_write_begin": [=
=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "per=
f-profile.cpu-cycles.path_openat.do_sys_open.sys_openat.system_call_fastpat=
h": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A =
 "perf-profile.cpu-cycles.mntput_no_expire.mntput.terminate_walk.path_looku=
pat.filename_lookup": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.02,=0A =
   0.02=0A  ],=0A  "perf-profile.cpu-cycles.might_fault.SYSC_newfstat.sys_n=
ewfstat.system_call_fastpath.__fxstat64": [=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.memcg_che=
ck_events.__mem_cgroup_commit_charge.mem_cgroup_charge_file.__add_to_page_c=
ache_locked.add_to_page_cache_lru": [=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.native_write_ms=
r_safe.lapic_next_deadline.clockevents_program_event.tick_program_event.hrt=
imer_interrupt": [=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.page_mapping.wait_for_stable_page.grab_cache_page_write_begi=
n.simple_write_begin.generic_perform_write": [=0A    0.01,=0A    0.01,=0A  =
  0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.follow_m=
anaged.path_lookupat.filename_lookup.user_path_at_empty.user_path_at": [=0A=
    0.01,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.copy_page_to_iter_iovec.generic_file_read_iter.new_sync_read.=
vfs_read.sys_pread64": [=0A    0.01,=0A    0.01,=0A    0,=0A    0.01,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.might_fault.system_call_fastpath"=
: [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "=
perf-profile.cpu-cycles.vfs_getattr.SYSC_newstat.sys_newstat.system_call_fa=
stpath.__xstat64": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__d_loo=
kup.d_lookup.lookup_dcache.__lookup_hash.do_unlinkat": [=0A    0.01,=0A    =
0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycle=
s.dput.filename_lookup.user_path_at_empty.user_path_at.vfs_fstatat": [=0A  =
  0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-pro=
file.cpu-cycles.__d_lookup.lookup_dcache.__lookup_hash.lookup_slow.path_loo=
kupat": [=0A    0.01,=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A=
  "perf-profile.cpu-cycles.mutex_lock.path_lookupat.filename_lookup.user_pa=
th_at_empty.user_path_at": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.module_put.__fput.____fput=
=2Etask_work_run.do_notify_resume": [=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.vfs_fstat.SYSC_=
newfstat.sys_newfstat.system_call_fastpath.__fxstat64": [=0A    0.01,=0A   =
 0.02,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycl=
es.d_set_d_op.simple_lookup.lookup_real.do_last.path_openat": [=0A    0.01,=
=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.memcg_=
check_events.__mem_cgroup_uncharge_common.mem_cgroup_uncharge_cache_page.de=
lete_from_page_cache.truncate_inode_page": [=0A    0.01,=0A    0.01,=0A    =
0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.in_group_p=
=2Egeneric_permission.__inode_permission.inode_permission.link_path_walk": =
[=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "pe=
rf-profile.cpu-cycles.__add_to_page_cache_locked.pagecache_get_page.grab_ca=
che_page_write_begin.simple_write_begin.generic_perform_write": [=0A    0.0=
1,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.__percpu_counter_add.__sb_end_write.vfs_write.sys_pwrite64.syste=
m_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0=
=2E01=0A  ],=0A  "perf-profile.cpu-cycles.mntput.do_last.path_openat.do_fil=
p_open.do_sys_open": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A  =
  0.01=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.might_fault.cp_new=
_stat.SYSC_newfstat.sys_newfstat": [=0A    0.01,=0A    0.01,=0A    0.01,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.page_mapping.set_p=
age_dirty.simple_write_end.generic_perform_write.__generic_file_write_iter"=
: [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "=
perf-profile.cpu-cycles.__sb_start_write.mnt_want_write.do_unlinkat.sys_unl=
ink.system_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.dcache_dir_open.finish_ope=
n.do_last.path_openat.do_filp_open": [=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.security_task_kill.group_send_sig_info.kill_pid_info.SYSC_kill.s=
ys_kill": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles.call_rcu_sched.____fput.task_work_run.do_no=
tify_resume.int_signal": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.security_file_permission.vf=
s_read.sys_pread64.system_call_fastpath.pread64": [=0A    0.01,=0A    0.02,=
=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__w=
ake_up_bit.wake_up_bit.evict.iput.do_unlinkat": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mnt=
put_no_expire.path_put.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.__mark_inode_dirty.simple_setattr.notify_change.utimes_common.do_u=
times": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.__mnt_want_write.touch_atime.iterate_dir.sys_=
getdents.system_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A   =
 0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__slab_alloc.kmem_cac=
he_alloc.selinux_inode_alloc_security.security_inode_alloc.inode_init_alway=
s": [=0A    0.01,=0A    0.01,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "p=
erf-profile.cpu-cycles.may_delete.vfs_unlink.do_unlinkat.sys_unlink.system_=
call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles._cond_resched.new_sync_read.vfs_read.=
sys_pread64.system_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.terminate_walk.pat=
h_openat.do_filp_open.do_sys_open.sys_open": [=0A    0.01,=0A    0.01,=0A  =
  0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.vfs_crea=
te.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__c=
lose_fd.system_call_fastpath.close": [=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.strncpy_from_user.getname.do_sys_open.sys_open.system_call_fastp=
ath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  =
"perf-profile.cpu-cycles._raw_spin_unlock.dput.terminate_walk.path_lookupat=
=2Efilename_lookup": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.ima_f=
ile_check.path_openat.do_filp_open.do_sys_open.sys_open": [=0A    0.01,=0A =
   0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cy=
cles.cp_new_stat.sys_newfstat.system_call_fastpath.__fxstat64": [=0A    0.0=
1,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.terminate_walk.do_last.path_openat.do_filp_open.do_sys_open": [=
=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.getname_flags.do_sys_open.sys_openat.system_call_fastp=
ath": [=0A    0.01,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profil=
e.cpu-cycles.do_filp_open.sys_open.system_call_fastpath.open64": [=0A    0.=
01,=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.lockref_mark_dead.dput.dcache_dir_close.__fput.____fput": [=
=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__mark_inode_di=
rty.update_time.touch_atime.generic_file_read_iter.new_sync_read": [=0A    =
0.01,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profi=
le.cpu-cycles.mutex_unlock.path_openat.do_filp_open.do_sys_open.sys_open": =
[=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "pe=
rf-profile.cpu-cycles.lookup_fast.path_openat.do_filp_open.do_sys_open.sys_=
open": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__inc_zone_state.ge=
t_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cach=
e_alloc": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles.__percpu_counter_add.path_openat.do_filp_op=
en.do_sys_open.sys_open": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.path_init.path_lookupat.fil=
ename_lookup.user_path_parent.do_unlinkat": [=0A    0.01,=0A    0.01,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.d_alloc.__lookup_hash.lookup_slow=
=2Epath_lookupat.filename_lookup": [=0A    0.01,=0A    0.01,=0A    0.01,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__percpu_counter_a=
dd.__sb_start_write.vfs_write.sys_pwrite64.system_call_fastpath": [=0A    0=
=2E01,=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.open_check_o_direct.path_openat.do_filp_open.do_sys_open.sys_=
open": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.fsnotify_find_inode=
_mark.filp_close.__close_fd.sys_close.system_call_fastpath": [=0A    0.01,=
=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.__mutex_init.path_openat.do_filp_open.do_sys_open.sys_open": [=0A =
   0.01,=0A    0.01,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.may_open.path_openat.do_filp_open.do_sys_open.sys_open": [=0A   =
 0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.mntput_no_expire.__fput.____fput.task_work_run.do_notify_res=
ume": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.integrity_iint_find.__fput.____fput.task_work=
_run.do_notify_resume": [=0A    0.01,=0A    0.01,=0A    0,=0A    0.01,=0A  =
  0.01=0A  ],=0A  "perf-profile.cpu-cycles.__zone_watermark_ok.__alloc_page=
s_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page": [=0A=
    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.mem_cgroup_charge_statistics.isra.20.__mem_cgroup_uncharg=
e_common.mem_cgroup_uncharge_cache_page.delete_from_page_cache.truncate_ino=
de_page": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles.system_call_fastpath.kill": [=0A    0.01,=
=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.curren=
t_fs_time.touch_atime.generic_file_read_iter.new_sync_read.vfs_read": [=0A =
   0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.__d_rehash.d_rehash.simple_lookup.lookup_real.__lookup_has=
h": [=0A    0.01,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf=
-profile.cpu-cycles.terminate_walk.path_openat.do_filp_open.do_sys_open.sys=
_openat": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles._d_rehash.simple_lookup.lookup_real.__looku=
p_hash.lookup_slow": [=0A    0.01,=0A    0,=0A    0.01,=0A    0.01,=0A    0=
=2E01=0A  ],=0A  "perf-profile.cpu-cycles.__alloc_pages_nodemask.__page_cac=
he_alloc.pagecache_get_page.grab_cache_page_write_begin.simple_write_begin"=
: [=0A    0.01,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.map_id_up.from_kuid_munged.cp_new_stat.SYSC_newstat.sys_newstat": =
[=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "pe=
rf-profile.cpu-cycles.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.__might_sleep.might_fault.cp_new_stat.SYSC_newstat.sys_newstat": [=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "per=
f-profile.cpu-cycles.__mod_zone_page_state.free_pcppages_bulk.free_hot_cold=
_page.free_hot_cold_page_list.release_pages": [=0A    0.01,=0A    0.01,=0A =
   0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.selinux=
_file_permission.rw_verify_area.vfs_write.sys_pwrite64.system_call_fastpath=
": [=0A    0.01,=0A    0.01,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-=
profile.cpu-cycles.vfs_getattr_nosec.vfs_getattr.vfs_fstat.SYSC_newfstat.sy=
s_newfstat": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "p=
erf-profile.cpu-cycles.path_lookupat.filename_lookup.user_path_at_empty.use=
r_path_at.user_statfs": [=0A    0.01,=0A    0.01,=0A    0,=0A    0.01,=0A  =
  0.01=0A  ],=0A  "perf-profile.cpu-cycles.new_sync_read.sys_pread64.system=
_call_fastpath.pread64": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.iov_iter_advance.__generic_=
file_write_iter.generic_file_write_iter.new_sync_write.vfs_write": [=0A    =
0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profi=
le.cpu-cycles._copy_to_user.SYSC_newfstat.sys_newfstat.system_call_fastpath=
=2E__fxstat64": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles.__dentry_kill.dput.do_unlinkat.sys_un=
link.system_call_fastpath": [=0A    0.01,=0A    0,=0A    0,=0A    0.01,=0A =
   0.01=0A  ],=0A  "perf-profile.cpu-cycles.security_d_instantiate.d_instan=
tiate.simple_lookup.lookup_real.__lookup_hash": [=0A    0.01,=0A    0.02=0A=
  ],=0A  "perf-profile.cpu-cycles.vfs_getattr.vfs_fstatat.SYSC_newstat.sys_=
newstat.system_call_fastpath": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cy=
cles.__sb_end_write.mnt_drop_write.do_unlinkat.sys_unlink.system_call_fastp=
ath": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.dput.path_openat.do_=
filp_open.do_sys_open.sys_open": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-=
cycles.mntput_no_expire.terminate_walk.path_lookupat.filename_lookup.user_p=
ath_at_empty": [=0A    0.01,=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.finish_open.path_openat.do_filp_open.do_sys_o=
pen.sys_openat": [=0A    0.01,=0A    0,=0A    0,=0A    0.01,=0A    0.01=0A =
 ],=0A  "perf-profile.cpu-cycles.path_put.SYSC_newstat.sys_newstat.system_c=
all_fastpath.__xstat64": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mntput.path_openat.do_filp_=
open.do_sys_open.sys_openat": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0=
=2E02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__lookup_hash.lookup_=
slow.path_lookupat.filename_lookup.user_path_at_empty": [=0A    0.01,=0A   =
 0,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.=
SYSC_newfstat.system_call_fastpath.__fxstat64": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.sel=
inux_file_permission.security_file_permission.rw_verify_area.vfs_read.sys_r=
ead": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.get_partial_node.isra.49.__slab_alloc.kmem_ca=
che_alloc.__d_alloc.d_alloc": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cyc=
les.putname.sys_openat.system_call_fastpath": [=0A    0.01,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles.fsnotify_clear_marks_by_inode.__fsnotify_in=
ode_delete.d_delete.vfs_unlink.do_unlinkat": [=0A    0.01,=0A    0.01,=0A  =
  0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.iov_iter=
_init.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=0A    0=
=2E01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.vfs_getattr.vfs_fstat.SYSC_newfstat.sys_newfstat.system_call=
_fastpath": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.user_path_pare=
nt.sys_unlink.system_call_fastpath.unlink": [=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.native_write_msr_safe.intel_pmu_disable_all.x86_pmu_disab=
le.perf_pmu_disable.perf_adjust_freq_unthr_context": [=0A    0.01,=0A    0.=
01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.current_kernel_time.touc=
h_atime.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.01,=0A   =
 0,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mut=
ex_lock.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.01,=0A    =
0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycle=
s.copy_page_to_iter.new_sync_read.vfs_read.sys_pread64.system_call_fastpath=
": [=0A    0.01,=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "pe=
rf-profile.cpu-cycles.selinux_inode_getattr.vfs_getattr.vfs_fstat.SYSC_newf=
stat.sys_newfstat": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.getname.sys_open.system_call_fast=
path.open64": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__lru_cache_=
add.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin.si=
mple_write_begin": [=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.__mnt_want_write.mnt_want_write.SYSC_renameat2.sys_rename.=
system_call_fastpath": [=0A    0.01,=0A    0,=0A    0,=0A    0.01=0A  ],=0A=
  "perf-profile.cpu-cycles.current_umask.path_openat.do_filp_open.do_sys_op=
en.sys_open": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles._IO_file_underflow": [=0A    0.01,=0A =
   0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cy=
cles._IO_switch_to_get_mode": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.generic_delete_inode.=
do_unlinkat.sys_unlink.system_call_fastpath.unlink": [=0A    0.01,=0A    0.=
01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.=
strrchr@plt": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.strtol@plt": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.int=
_signal.close": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles.@plt": [=0A    0.01,=0A    0.01,=0A  =
  0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.open@plt": =
[=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "pe=
rf-profile.cpu-cycles.utime": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.memalign@plt": [=0A  =
  0.01,=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-pro=
file.cpu-cycles.free@plt": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.memcpy.mga_imageblit.soft_=
cursor.bit_cursor.fb_flashcursor": [=0A    0.01,=0A    0.01,=0A    0.01,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__statfs": [=0A   =
 0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.closedir@plt": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.address_space_init_on=
ce.inode_init_once.init_once.new_slab.__slab_alloc": [=0A    0.01,=0A    0,=
=0A    0,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.read":=
 [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "p=
erf-profile.cpu-cycles._IO_file_read": [=0A    0.01,=0A    0.01=0A  ],=0A  =
"perf-profile.cpu-cycles.x86_pmu_disable.perf_adjust_freq_unthr_context.per=
f_event_task_tick.scheduler_tick.update_process_times": [=0A    0.01,=0A   =
 0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycl=
es.memmove@plt": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles.kmalloc_slab.kstrdup.vfs_rename.SYSC=
_renameat2.sys_rename": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.kill@plt": [=0A    0.01,=0A=
    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-c=
ycles.inode_has_buffers.destroy_inode.evict.iput.do_unlinkat": [=0A    0.01=
,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.c=
pu-cycles.rename": [=0A    0.01,=0A    0.01,=0A    0,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_create.vfs_create.do_la=
st.path_openat.do_filp_open": [=0A    0.01,=0A    0.01=0A  ],=0A  "cpuidle.=
POLL.time": [=0A    548,=0A    839,=0A    491,=0A    884,=0A    419=0A  ],=
=0A  "cpuidle.POLL.usage": [=0A    50,=0A    75,=0A    44,=0A    71,=0A    =
38=0A  ],=0A  "cpuidle.C1-IVT.time": [=0A    223754211,=0A    275950688,=0A=
    196153894,=0A    279121595,=0A    199205211=0A  ],=0A  "cpuidle.C1-IVT.=
usage": [=0A    995401,=0A    1235056,=0A    723545,=0A    1309760,=0A    8=
92672=0A  ],=0A  "cpuidle.C1E-IVT.time": [=0A    55260500,=0A    61311411,=
=0A    41806089,=0A    71404320,=0A    51776605=0A  ],=0A  "cpuidle.C1E-IVT=
=2Eusage": [=0A    179086,=0A    201516,=0A    135176,=0A    225722,=0A    =
160000=0A  ],=0A  "cpuidle.C3-IVT.time": [=0A    8509239,=0A    10611194,=
=0A    6034390,=0A    12378990,=0A    8709029=0A  ],=0A  "cpuidle.C3-IVT.us=
age": [=0A    27967,=0A    35953,=0A    19974,=0A    37738,=0A    26340=0A =
 ],=0A  "cpuidle.C6-IVT.time": [=0A    472490125,=0A    532501017,=0A    39=
7320254,=0A    491949807,=0A    431191136=0A  ],=0A  "cpuidle.C6-IVT.usage"=
: [=0A    632129,=0A    723308,=0A    508445,=0A    669543,=0A    541529=0A=
  ],=0A  "energy.energy-cores": [=0A    4.047665594875423e-08,=0A    4.0447=
830554038134e-08,=0A    4.053789255205479e-08,=0A    4.047278596486753e-08,=
=0A    4.0532082452576204e-08=0A  ],=0A  "energy.energy-pkg": [=0A    4.868=
2996855350816e-08,=0A    4.8671596532542496e-08,=0A    4.875493654450358e-0=
8,=0A    4.870054823369105e-08,=0A    4.877800604255512e-08=0A  ],=0A  "ene=
rgy.energy-ram": [=0A    4.0328922009095165e-09,=0A    4.0372117840470705e-=
09,=0A    4.061523728784211e-09,=0A    4.041205376012687e-09,=0A    4.05694=
9696422644e-09=0A  ],=0A  "dbench.throughput-MB/sec": [=0A    24913.9,=0A  =
  24929.7,=0A    25041.2,=0A    24786.7,=0A    24896.6=0A  ],=0A  "dbench.c=
lients": [=0A    48,=0A    48,=0A    48,=0A    48,=0A    48=0A  ],=0A  "dbe=
nch.procs": [=0A    48,=0A    48,=0A    48,=0A    48,=0A    48=0A  ],=0A  "=
dbench.max_latency": [=0A    86.147,=0A    62.496,=0A    62.566,=0A    66.8=
51,=0A    63.859=0A  ],=0A  "turbostat.%c0": [=0A    97.81,=0A    97.46,=0A=
    98.15,=0A    97.53,=0A    98.01=0A  ],=0A  "turbostat.GHz": [=0A    2.9=
9,=0A    2.99,=0A    2.99,=0A    2.99,=0A    2.99=0A  ],=0A  "turbostat.TSC=
": [=0A    2.69,=0A    2.69,=0A    2.69,=0A    2.69,=0A    2.69=0A  ],=0A  =
"turbostat.%c1": [=0A    2.06,=0A    2.38,=0A    1.72,=0A    2.31,=0A    1.=
85=0A  ],=0A  "turbostat.%c6": [=0A    0.13,=0A    0.15,=0A    0.13,=0A    =
0.15,=0A    0.14=0A  ],=0A  "turbostat.CTMP": [=0A    70,=0A    71,=0A    7=
1,=0A    70,=0A    71=0A  ],=0A  "turbostat.PTMP": [=0A    70,=0A    70,=0A=
    71,=0A    70,=0A    71=0A  ],=0A  "turbostat.Pkg_W": [=0A    211.67,=0A=
    211.62,=0A    211.98,=0A    211.75,=0A    212.08=0A  ],=0A  "turbostat.=
Cor_W": [=0A    175.99,=0A    175.86,=0A    176.26,=0A    175.97,=0A    176=
=2E23=0A  ],=0A  "turbostat.RAM_W": [=0A    17.53,=0A    17.55,=0A    17.66=
,=0A    17.57,=0A    17.64=0A  ],=0A  "interrupts.CPU0.0:IO-APIC-edge.timer=
": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.0:I=
O-APIC-edge.timer": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A=
  "interrupts.CPU0.4:IO-APIC-edge.serial": [=0A    35,=0A    35,=0A    35,=
=0A    35,=0A    35=0A  ],=0A  "interrupts.4:IO-APIC-edge.serial": [=0A    =
35,=0A    35,=0A    35,=0A    35,=0A    35=0A  ],=0A  "interrupts.CPU0.8:IO=
-APIC-edge.rtc0": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  =
"interrupts.8:IO-APIC-edge.rtc0": [=0A    0,=0A    0,=0A    0,=0A    0,=0A =
   0=0A  ],=0A  "interrupts.CPU0.20:IO-APIC-fasteoi.ehci_hcd:usb2": [=0A   =
 0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.20:IO-APIC-fa=
steoi.ehci_hcd:usb2": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=
=0A  "interrupts.CPU0.22:IO-APIC-fasteoi.ehci_hcd:usb1": [=0A    0,=0A    0=
,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.22:IO-APIC-fasteoi.ehci_=
hcd:usb1": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interr=
upts.CPU0.96:PCI-MSI-edge.eth0": [=0A    0,=0A    0,=0A    0,=0A    0,=0A  =
  0=0A  ],=0A  "interrupts.96:PCI-MSI-edge.eth0": [=0A    0,=0A    0,=0A   =
 0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.97:PCI-MSI-edge.eth0-TxRx-=
0": [=0A    2742,=0A    2191,=0A    2453,=0A    2571,=0A    2166=0A  ],=0A =
 "interrupts.97:PCI-MSI-edge.eth0-TxRx-0": [=0A    2742,=0A    2191,=0A    =
2453,=0A    2571,=0A    2166=0A  ],=0A  "interrupts.CPU0.98:PCI-MSI-edge.et=
h0-TxRx-1": [=0A    369,=0A    369,=0A    369,=0A    368,=0A    372=0A  ],=
=0A  "interrupts.98:PCI-MSI-edge.eth0-TxRx-1": [=0A    369,=0A    369,=0A  =
  369,=0A    368,=0A    372=0A  ],=0A  "interrupts.CPU0.99:PCI-MSI-edge.eth=
0-TxRx-2": [=0A    555,=0A    580,=0A    555,=0A    667,=0A    591=0A  ],=
=0A  "interrupts.99:PCI-MSI-edge.eth0-TxRx-2": [=0A    555,=0A    580,=0A  =
  555,=0A    667,=0A    591=0A  ],=0A  "interrupts.CPU0.100:PCI-MSI-edge.et=
h0-TxRx-3": [=0A    379,=0A    576,=0A    378,=0A    378,=0A    380=0A  ],=
=0A  "interrupts.100:PCI-MSI-edge.eth0-TxRx-3": [=0A    379,=0A    576,=0A =
   378,=0A    378,=0A    380=0A  ],=0A  "interrupts.CPU0.101:PCI-MSI-edge.e=
th0-TxRx-4": [=0A    450,=0A    459,=0A    533,=0A    445,=0A    551=0A  ],=
=0A  "interrupts.101:PCI-MSI-edge.eth0-TxRx-4": [=0A    450,=0A    459,=0A =
   533,=0A    445,=0A    551=0A  ],=0A  "interrupts.CPU0.102:PCI-MSI-edge.e=
th0-TxRx-5": [=0A    374,=0A    374,=0A    369,=0A    457,=0A    371=0A  ],=
=0A  "interrupts.102:PCI-MSI-edge.eth0-TxRx-5": [=0A    374,=0A    374,=0A =
   369,=0A    457,=0A    371=0A  ],=0A  "interrupts.CPU0.103:PCI-MSI-edge.e=
th0-TxRx-6": [=0A    364,=0A    366,=0A    364,=0A    363,=0A    367=0A  ],=
=0A  "interrupts.103:PCI-MSI-edge.eth0-TxRx-6": [=0A    364,=0A    366,=0A =
   364,=0A    363,=0A    367=0A  ],=0A  "interrupts.CPU0.104:PCI-MSI-edge.e=
th0-TxRx-7": [=0A    451,=0A    372,=0A    380,=0A    372,=0A    376=0A  ],=
=0A  "interrupts.104:PCI-MSI-edge.eth0-TxRx-7": [=0A    451,=0A    372,=0A =
   380,=0A    372,=0A    376=0A  ],=0A  "interrupts.CPU0.106:PCI-MSI-edge":=
 [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.106:P=
CI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "int=
errupts.CPU0.107:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A   =
 0=0A  ],=0A  "interrupts.107:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=
=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.108:PCI-MSI-edge": [=0A    0,=
=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.108:PCI-MSI-edge=
": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU=
0.109:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=
=0A  "interrupts.109:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=
=0A    0=0A  ],=0A  "interrupts.CPU0.110:PCI-MSI-edge": [=0A    0,=0A    0,=
=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.110:PCI-MSI-edge": [=0A  =
  0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.111:PCI=
-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "inter=
rupts.111:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  =
],=0A  "interrupts.CPU0.112:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A =
   0,=0A    0=0A  ],=0A  "interrupts.112:PCI-MSI-edge": [=0A    0,=0A    0,=
=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.113:PCI-MSI-edge": [=
=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.113:PCI=
-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "inter=
rupts.CPU0.NMI:Non-maskable_interrupts": [=0A    39108,=0A    39163,=0A    =
39799,=0A    39698,=0A    39680=0A  ],=0A  "interrupts.CPU1.NMI:Non-maskabl=
e_interrupts": [=0A    39220,=0A    39440,=0A    39809,=0A    39923,=0A    =
39922=0A  ],=0A  "interrupts.CPU2.NMI:Non-maskable_interrupts": [=0A    396=
70,=0A    39311,=0A    39901,=0A    39761,=0A    39789=0A  ],=0A  "interrup=
ts.CPU3.NMI:Non-maskable_interrupts": [=0A    39272,=0A    39342,=0A    395=
06,=0A    39812,=0A    39328=0A  ],=0A  "interrupts.CPU4.NMI:Non-maskable_i=
nterrupts": [=0A    39635,=0A    39544,=0A    39296,=0A    39434,=0A    398=
39=0A  ],=0A  "interrupts.CPU5.NMI:Non-maskable_interrupts": [=0A    39051,=
=0A    39364,=0A    39833,=0A    39373,=0A    39568=0A  ],=0A  "interrupts.=
CPU6.NMI:Non-maskable_interrupts": [=0A    39682,=0A    39681,=0A    39569,=
=0A    39447,=0A    39590=0A  ],=0A  "interrupts.CPU7.NMI:Non-maskable_inte=
rrupts": [=0A    39344,=0A    39281,=0A    39642,=0A    39559,=0A    39916=
=0A  ],=0A  "interrupts.CPU8.NMI:Non-maskable_interrupts": [=0A    39645,=
=0A    39331,=0A    39792,=0A    39744,=0A    39741=0A  ],=0A  "interrupts.=
CPU9.NMI:Non-maskable_interrupts": [=0A    39828,=0A    39356,=0A    39675,=
=0A    39843,=0A    39416=0A  ],=0A  "interrupts.CPU10.NMI:Non-maskable_int=
errupts": [=0A    39266,=0A    39404,=0A    39932,=0A    39699,=0A    39175=
=0A  ],=0A  "interrupts.CPU11.NMI:Non-maskable_interrupts": [=0A    39286,=
=0A    39145,=0A    39836,=0A    39126,=0A    39346=0A  ],=0A  "interrupts.=
CPU12.NMI:Non-maskable_interrupts": [=0A    39223,=0A    38654,=0A    38507=
,=0A    38680,=0A    38803=0A  ],=0A  "interrupts.CPU13.NMI:Non-maskable_in=
terrupts": [=0A    38418,=0A    38899,=0A    39143,=0A    38956,=0A    3932=
2=0A  ],=0A  "interrupts.CPU14.NMI:Non-maskable_interrupts": [=0A    37539,=
=0A    38422,=0A    39877,=0A    39052,=0A    38074=0A  ],=0A  "interrupts.=
CPU15.NMI:Non-maskable_interrupts": [=0A    39446,=0A    39264,=0A    38491=
,=0A    38331,=0A    38528=0A  ],=0A  "interrupts.CPU16.NMI:Non-maskable_in=
terrupts": [=0A    38980,=0A    38681,=0A    39534,=0A    39568,=0A    3853=
4=0A  ],=0A  "interrupts.CPU17.NMI:Non-maskable_interrupts": [=0A    38372,=
=0A    39530,=0A    39809,=0A    39258,=0A    39587=0A  ],=0A  "interrupts.=
CPU18.NMI:Non-maskable_interrupts": [=0A    38913,=0A    39105,=0A    38829=
,=0A    37665,=0A    39195=0A  ],=0A  "interrupts.CPU19.NMI:Non-maskable_in=
terrupts": [=0A    37680,=0A    38906,=0A    39942,=0A    39221,=0A    3947=
6=0A  ],=0A  "interrupts.CPU20.NMI:Non-maskable_interrupts": [=0A    39440,=
=0A    39120,=0A    39887,=0A    38930,=0A    39642=0A  ],=0A  "interrupts.=
CPU21.NMI:Non-maskable_interrupts": [=0A    38835,=0A    39421,=0A    39117=
,=0A    37355,=0A    38917=0A  ],=0A  "interrupts.CPU22.NMI:Non-maskable_in=
terrupts": [=0A    38953,=0A    37960,=0A    39610,=0A    37833,=0A    3847=
3=0A  ],=0A  "interrupts.CPU23.NMI:Non-maskable_interrupts": [=0A    38420,=
=0A    38039,=0A    38731,=0A    38704,=0A    39649=0A  ],=0A  "interrupts.=
CPU24.NMI:Non-maskable_interrupts": [=0A    38771,=0A    38938,=0A    39893=
,=0A    39737,=0A    39259=0A  ],=0A  "interrupts.CPU25.NMI:Non-maskable_in=
terrupts": [=0A    39323,=0A    39539,=0A    39556,=0A    39828,=0A    3980=
5=0A  ],=0A  "interrupts.CPU26.NMI:Non-maskable_interrupts": [=0A    39445,=
=0A    39632,=0A    39345,=0A    39456,=0A    39248=0A  ],=0A  "interrupts.=
CPU27.NMI:Non-maskable_interrupts": [=0A    39556,=0A    39510,=0A    39731=
,=0A    39223,=0A    39545=0A  ],=0A  "interrupts.CPU28.NMI:Non-maskable_in=
terrupts": [=0A    39552,=0A    39385,=0A    39900,=0A    39943,=0A    3961=
1=0A  ],=0A  "interrupts.CPU29.NMI:Non-maskable_interrupts": [=0A    39353,=
=0A    39236,=0A    39372,=0A    39499,=0A    39664=0A  ],=0A  "interrupts.=
CPU30.NMI:Non-maskable_interrupts": [=0A    38649,=0A    39149,=0A    39888=
,=0A    39948,=0A    39427=0A  ],=0A  "interrupts.CPU31.NMI:Non-maskable_in=
terrupts": [=0A    39429,=0A    38988,=0A    39837,=0A    39791,=0A    3921=
1=0A  ],=0A  "interrupts.CPU32.NMI:Non-maskable_interrupts": [=0A    39132,=
=0A    39315,=0A    39866,=0A    39712,=0A    39761=0A  ],=0A  "interrupts.=
CPU33.NMI:Non-maskable_interrupts": [=0A    38531,=0A    39341,=0A    39386=
,=0A    39300,=0A    39437=0A  ],=0A  "interrupts.CPU34.NMI:Non-maskable_in=
terrupts": [=0A    39433,=0A    38873,=0A    39568,=0A    39846,=0A    3981=
2=0A  ],=0A  "interrupts.CPU35.NMI:Non-maskable_interrupts": [=0A    39376,=
=0A    38706,=0A    39940,=0A    39917,=0A    39562=0A  ],=0A  "interrupts.=
CPU36.NMI:Non-maskable_interrupts": [=0A    38644,=0A    38954,=0A    39824=
,=0A    37812,=0A    39350=0A  ],=0A  "interrupts.CPU37.NMI:Non-maskable_in=
terrupts": [=0A    38778,=0A    37179,=0A    39614,=0A    38922,=0A    3772=
8=0A  ],=0A  "interrupts.CPU38.NMI:Non-maskable_interrupts": [=0A    38134,=
=0A    38429,=0A    39762,=0A    38946,=0A    38863=0A  ],=0A  "interrupts.=
CPU39.NMI:Non-maskable_interrupts": [=0A    38166,=0A    36683,=0A    38461=
,=0A    37859,=0A    39367=0A  ],=0A  "interrupts.CPU40.NMI:Non-maskable_in=
terrupts": [=0A    38714,=0A    39056,=0A    38480,=0A    38528,=0A    3886=
6=0A  ],=0A  "interrupts.CPU41.NMI:Non-maskable_interrupts": [=0A    39272,=
=0A    38137,=0A    38552,=0A    38893,=0A    37588=0A  ],=0A  "interrupts.=
CPU42.NMI:Non-maskable_interrupts": [=0A    38371,=0A    38026,=0A    39396=
,=0A    39070,=0A    39164=0A  ],=0A  "interrupts.CPU43.NMI:Non-maskable_in=
terrupts": [=0A    38612,=0A    38662,=0A    39775,=0A    38885,=0A    3940=
0=0A  ],=0A  "interrupts.CPU44.NMI:Non-maskable_interrupts": [=0A    38376,=
=0A    38389,=0A    38408,=0A    38452,=0A    38620=0A  ],=0A  "interrupts.=
CPU45.NMI:Non-maskable_interrupts": [=0A    37807,=0A    37620,=0A    39591=
,=0A    37845,=0A    38839=0A  ],=0A  "interrupts.CPU46.NMI:Non-maskable_in=
terrupts": [=0A    38669,=0A    39267,=0A    38805,=0A    38936,=0A    3894=
1=0A  ],=0A  "interrupts.CPU47.NMI:Non-maskable_interrupts": [=0A    38654,=
=0A    38054,=0A    39895,=0A    38400,=0A    38086=0A  ],=0A  "interrupts.=
NMI:Non-maskable_interrupts": [=0A    1869973,=0A    1867431,=0A    1894912=
,=0A    1877720,=0A    1882664=0A  ],=0A  "interrupts.CPU0.LOC:Local_timer_=
interrupts": [=0A    713171,=0A    712605,=0A    713786,=0A    713256,=0A  =
  713917=0A  ],=0A  "interrupts.CPU1.LOC:Local_timer_interrupts": [=0A    7=
11200,=0A    711142,=0A    712689,=0A    710807,=0A    713303=0A  ],=0A  "i=
nterrupts.CPU2.LOC:Local_timer_interrupts": [=0A    712082,=0A    710886,=
=0A    712935,=0A    711919,=0A    713173=0A  ],=0A  "interrupts.CPU3.LOC:L=
ocal_timer_interrupts": [=0A    710723,=0A    710930,=0A    713370,=0A    7=
11614,=0A    712888=0A  ],=0A  "interrupts.CPU4.LOC:Local_timer_interrupts"=
: [=0A    711928,=0A    710578,=0A    712652,=0A    711249,=0A    712570=0A=
  ],=0A  "interrupts.CPU5.LOC:Local_timer_interrupts": [=0A    710282,=0A  =
  710163,=0A    712204,=0A    710808,=0A    713107=0A  ],=0A  "interrupts.C=
PU6.LOC:Local_timer_interrupts": [=0A    710498,=0A    710122,=0A    712555=
,=0A    710348,=0A    712371=0A  ],=0A  "interrupts.CPU7.LOC:Local_timer_in=
terrupts": [=0A    712036,=0A    710117,=0A    711985,=0A    710014,=0A    =
713701=0A  ],=0A  "interrupts.CPU8.LOC:Local_timer_interrupts": [=0A    711=
240,=0A    710084,=0A    712272,=0A    710167,=0A    712480=0A  ],=0A  "int=
errupts.CPU9.LOC:Local_timer_interrupts": [=0A    711151,=0A    709783,=0A =
   713262,=0A    710677,=0A    712842=0A  ],=0A  "interrupts.CPU10.LOC:Loca=
l_timer_interrupts": [=0A    710815,=0A    710310,=0A    712565,=0A    7096=
58,=0A    712621=0A  ],=0A  "interrupts.CPU11.LOC:Local_timer_interrupts": =
[=0A    711557,=0A    708972,=0A    714172,=0A    709476,=0A    712786=0A  =
],=0A  "interrupts.CPU12.LOC:Local_timer_interrupts": [=0A    703911,=0A   =
 699172,=0A    705557,=0A    704529,=0A    704592=0A  ],=0A  "interrupts.CP=
U13.LOC:Local_timer_interrupts": [=0A    703869,=0A    699876,=0A    704267=
,=0A    700602,=0A    706375=0A  ],=0A  "interrupts.CPU14.LOC:Local_timer_i=
nterrupts": [=0A    704423,=0A    701245,=0A    706813,=0A    700601,=0A   =
 705354=0A  ],=0A  "interrupts.CPU15.LOC:Local_timer_interrupts": [=0A    7=
03765,=0A    701386,=0A    704710,=0A    701200,=0A    704177=0A  ],=0A  "i=
nterrupts.CPU16.LOC:Local_timer_interrupts": [=0A    700866,=0A    699028,=
=0A    704706,=0A    700103,=0A    704762=0A  ],=0A  "interrupts.CPU17.LOC:=
Local_timer_interrupts": [=0A    702321,=0A    695854,=0A    704864,=0A    =
698055,=0A    706119=0A  ],=0A  "interrupts.CPU18.LOC:Local_timer_interrupt=
s": [=0A    702138,=0A    698289,=0A    705100,=0A    699473,=0A    704519=
=0A  ],=0A  "interrupts.CPU19.LOC:Local_timer_interrupts": [=0A    702070,=
=0A    698420,=0A    703135,=0A    696736,=0A    700814=0A  ],=0A  "interru=
pts.CPU20.LOC:Local_timer_interrupts": [=0A    700505,=0A    700576,=0A    =
703356,=0A    700922,=0A    703049=0A  ],=0A  "interrupts.CPU21.LOC:Local_t=
imer_interrupts": [=0A    698694,=0A    697162,=0A    703221,=0A    698463,=
=0A    701958=0A  ],=0A  "interrupts.CPU22.LOC:Local_timer_interrupts": [=
=0A    701248,=0A    698885,=0A    701302,=0A    699666,=0A    703241=0A  ]=
,=0A  "interrupts.CPU23.LOC:Local_timer_interrupts": [=0A    698761,=0A    =
697714,=0A    701505,=0A    698997,=0A    702448=0A  ],=0A  "interrupts.CPU=
24.LOC:Local_timer_interrupts": [=0A    710850,=0A    709549,=0A    712401,=
=0A    709546,=0A    712941=0A  ],=0A  "interrupts.CPU25.LOC:Local_timer_in=
terrupts": [=0A    713534,=0A    708196,=0A    711246,=0A    711696,=0A    =
712141=0A  ],=0A  "interrupts.CPU26.LOC:Local_timer_interrupts": [=0A    71=
1487,=0A    709164,=0A    711429,=0A    709274,=0A    713593=0A  ],=0A  "in=
terrupts.CPU27.LOC:Local_timer_interrupts": [=0A    711509,=0A    710994,=
=0A    712084,=0A    708935,=0A    711858=0A  ],=0A  "interrupts.CPU28.LOC:=
Local_timer_interrupts": [=0A    710618,=0A    708957,=0A    712002,=0A    =
709502,=0A    712236=0A  ],=0A  "interrupts.CPU29.LOC:Local_timer_interrupt=
s": [=0A    711039,=0A    709041,=0A    712720,=0A    709054,=0A    712121=
=0A  ],=0A  "interrupts.CPU30.LOC:Local_timer_interrupts": [=0A    711181,=
=0A    710105,=0A    713154,=0A    709317,=0A    712329=0A  ],=0A  "interru=
pts.CPU31.LOC:Local_timer_interrupts": [=0A    709485,=0A    709804,=0A    =
713325,=0A    710034,=0A    712011=0A  ],=0A  "interrupts.CPU32.LOC:Local_t=
imer_interrupts": [=0A    710926,=0A    709185,=0A    711997,=0A    709132,=
=0A    712659=0A  ],=0A  "interrupts.CPU33.LOC:Local_timer_interrupts": [=
=0A    710473,=0A    710150,=0A    711759,=0A    707788,=0A    711731=0A  ]=
,=0A  "interrupts.CPU34.LOC:Local_timer_interrupts": [=0A    710262,=0A    =
708129,=0A    712665,=0A    708162,=0A    711178=0A  ],=0A  "interrupts.CPU=
35.LOC:Local_timer_interrupts": [=0A    709964,=0A    709161,=0A    712020,=
=0A    707786,=0A    711750=0A  ],=0A  "interrupts.CPU36.LOC:Local_timer_in=
terrupts": [=0A    702327,=0A    697296,=0A    705218,=0A    694431,=0A    =
700721=0A  ],=0A  "interrupts.CPU37.LOC:Local_timer_interrupts": [=0A    69=
7933,=0A    700227,=0A    704445,=0A    695082,=0A    700318=0A  ],=0A  "in=
terrupts.CPU38.LOC:Local_timer_interrupts": [=0A    702298,=0A    698449,=
=0A    704975,=0A    695545,=0A    701579=0A  ],=0A  "interrupts.CPU39.LOC:=
Local_timer_interrupts": [=0A    699112,=0A    694597,=0A    701398,=0A    =
693924,=0A    701989=0A  ],=0A  "interrupts.CPU40.LOC:Local_timer_interrupt=
s": [=0A    701239,=0A    694720,=0A    702201,=0A    697523,=0A    700687=
=0A  ],=0A  "interrupts.CPU41.LOC:Local_timer_interrupts": [=0A    698779,=
=0A    696848,=0A    702664,=0A    696463,=0A    699683=0A  ],=0A  "interru=
pts.CPU42.LOC:Local_timer_interrupts": [=0A    698220,=0A    693736,=0A    =
703241,=0A    697092,=0A    701623=0A  ],=0A  "interrupts.CPU43.LOC:Local_t=
imer_interrupts": [=0A    697066,=0A    697884,=0A    703487,=0A    693202,=
=0A    699564=0A  ],=0A  "interrupts.CPU44.LOC:Local_timer_interrupts": [=
=0A    700564,=0A    692796,=0A    702091,=0A    695013,=0A    698476=0A  ]=
,=0A  "interrupts.CPU45.LOC:Local_timer_interrupts": [=0A    699618,=0A    =
696728,=0A    702445,=0A    694430,=0A    697250=0A  ],=0A  "interrupts.CPU=
46.LOC:Local_timer_interrupts": [=0A    698493,=0A    695879,=0A    702190,=
=0A    694591,=0A    700113=0A  ],=0A  "interrupts.CPU47.LOC:Local_timer_in=
terrupts": [=0A    698779,=0A    695719,=0A    702218,=0A    694316,=0A    =
699490=0A  ],=0A  "interrupts.LOC:Local_timer_interrupts": [=0A    33885010=
,=0A    33780613,=0A    33986358,=0A    33781178,=0A    33951208=0A  ],=0A =
 "interrupts.CPU0.PMI:Performance_monitoring_interrupts": [=0A    39108,=0A=
    39163,=0A    39799,=0A    39698,=0A    39680=0A  ],=0A  "interrupts.CPU=
1.PMI:Performance_monitoring_interrupts": [=0A    39220,=0A    39440,=0A   =
 39809,=0A    39923,=0A    39922=0A  ],=0A  "interrupts.CPU2.PMI:Performanc=
e_monitoring_interrupts": [=0A    39670,=0A    39311,=0A    39901,=0A    39=
761,=0A    39789=0A  ],=0A  "interrupts.CPU3.PMI:Performance_monitoring_int=
errupts": [=0A    39272,=0A    39342,=0A    39506,=0A    39812,=0A    39328=
=0A  ],=0A  "interrupts.CPU4.PMI:Performance_monitoring_interrupts": [=0A  =
  39635,=0A    39544,=0A    39296,=0A    39434,=0A    39839=0A  ],=0A  "int=
errupts.CPU5.PMI:Performance_monitoring_interrupts": [=0A    39051,=0A    3=
9364,=0A    39833,=0A    39373,=0A    39568=0A  ],=0A  "interrupts.CPU6.PMI=
:Performance_monitoring_interrupts": [=0A    39682,=0A    39681,=0A    3956=
9,=0A    39447,=0A    39590=0A  ],=0A  "interrupts.CPU7.PMI:Performance_mon=
itoring_interrupts": [=0A    39344,=0A    39281,=0A    39642,=0A    39559,=
=0A    39916=0A  ],=0A  "interrupts.CPU8.PMI:Performance_monitoring_interru=
pts": [=0A    39645,=0A    39331,=0A    39792,=0A    39744,=0A    39741=0A =
 ],=0A  "interrupts.CPU9.PMI:Performance_monitoring_interrupts": [=0A    39=
828,=0A    39356,=0A    39675,=0A    39843,=0A    39416=0A  ],=0A  "interru=
pts.CPU10.PMI:Performance_monitoring_interrupts": [=0A    39266,=0A    3940=
4,=0A    39932,=0A    39699,=0A    39175=0A  ],=0A  "interrupts.CPU11.PMI:P=
erformance_monitoring_interrupts": [=0A    39286,=0A    39145,=0A    39836,=
=0A    39126,=0A    39346=0A  ],=0A  "interrupts.CPU12.PMI:Performance_moni=
toring_interrupts": [=0A    39223,=0A    38654,=0A    38507,=0A    38680,=
=0A    38803=0A  ],=0A  "interrupts.CPU13.PMI:Performance_monitoring_interr=
upts": [=0A    38418,=0A    38899,=0A    39143,=0A    38956,=0A    39322=0A=
  ],=0A  "interrupts.CPU14.PMI:Performance_monitoring_interrupts": [=0A    =
37539,=0A    38422,=0A    39877,=0A    39052,=0A    38074=0A  ],=0A  "inter=
rupts.CPU15.PMI:Performance_monitoring_interrupts": [=0A    39446,=0A    39=
264,=0A    38491,=0A    38331,=0A    38528=0A  ],=0A  "interrupts.CPU16.PMI=
:Performance_monitoring_interrupts": [=0A    38980,=0A    38681,=0A    3953=
4,=0A    39568,=0A    38534=0A  ],=0A  "interrupts.CPU17.PMI:Performance_mo=
nitoring_interrupts": [=0A    38372,=0A    39530,=0A    39809,=0A    39258,=
=0A    39587=0A  ],=0A  "interrupts.CPU18.PMI:Performance_monitoring_interr=
upts": [=0A    38913,=0A    39105,=0A    38829,=0A    37665,=0A    39195=0A=
  ],=0A  "interrupts.CPU19.PMI:Performance_monitoring_interrupts": [=0A    =
37680,=0A    38906,=0A    39942,=0A    39221,=0A    39476=0A  ],=0A  "inter=
rupts.CPU20.PMI:Performance_monitoring_interrupts": [=0A    39440,=0A    39=
120,=0A    39887,=0A    38930,=0A    39642=0A  ],=0A  "interrupts.CPU21.PMI=
:Performance_monitoring_interrupts": [=0A    38835,=0A    39421,=0A    3911=
7,=0A    37355,=0A    38917=0A  ],=0A  "interrupts.CPU22.PMI:Performance_mo=
nitoring_interrupts": [=0A    38953,=0A    37960,=0A    39610,=0A    37833,=
=0A    38473=0A  ],=0A  "interrupts.CPU23.PMI:Performance_monitoring_interr=
upts": [=0A    38420,=0A    38039,=0A    38731,=0A    38704,=0A    39649=0A=
  ],=0A  "interrupts.CPU24.PMI:Performance_monitoring_interrupts": [=0A    =
38771,=0A    38938,=0A    39893,=0A    39737,=0A    39259=0A  ],=0A  "inter=
rupts.CPU25.PMI:Performance_monitoring_interrupts": [=0A    39323,=0A    39=
539,=0A    39556,=0A    39828,=0A    39805=0A  ],=0A  "interrupts.CPU26.PMI=
:Performance_monitoring_interrupts": [=0A    39445,=0A    39632,=0A    3934=
5,=0A    39456,=0A    39248=0A  ],=0A  "interrupts.CPU27.PMI:Performance_mo=
nitoring_interrupts": [=0A    39556,=0A    39510,=0A    39731,=0A    39223,=
=0A    39545=0A  ],=0A  "interrupts.CPU28.PMI:Performance_monitoring_interr=
upts": [=0A    39552,=0A    39385,=0A    39900,=0A    39943,=0A    39611=0A=
  ],=0A  "interrupts.CPU29.PMI:Performance_monitoring_interrupts": [=0A    =
39353,=0A    39236,=0A    39372,=0A    39499,=0A    39664=0A  ],=0A  "inter=
rupts.CPU30.PMI:Performance_monitoring_interrupts": [=0A    38649,=0A    39=
149,=0A    39888,=0A    39948,=0A    39427=0A  ],=0A  "interrupts.CPU31.PMI=
:Performance_monitoring_interrupts": [=0A    39429,=0A    38988,=0A    3983=
7,=0A    39791,=0A    39211=0A  ],=0A  "interrupts.CPU32.PMI:Performance_mo=
nitoring_interrupts": [=0A    39132,=0A    39315,=0A    39866,=0A    39712,=
=0A    39761=0A  ],=0A  "interrupts.CPU33.PMI:Performance_monitoring_interr=
upts": [=0A    38531,=0A    39341,=0A    39386,=0A    39300,=0A    39437=0A=
  ],=0A  "interrupts.CPU34.PMI:Performance_monitoring_interrupts": [=0A    =
39433,=0A    38873,=0A    39568,=0A    39846,=0A    39812=0A  ],=0A  "inter=
rupts.CPU35.PMI:Performance_monitoring_interrupts": [=0A    39376,=0A    38=
706,=0A    39940,=0A    39917,=0A    39562=0A  ],=0A  "interrupts.CPU36.PMI=
:Performance_monitoring_interrupts": [=0A    38644,=0A    38954,=0A    3982=
4,=0A    37812,=0A    39350=0A  ],=0A  "interrupts.CPU37.PMI:Performance_mo=
nitoring_interrupts": [=0A    38778,=0A    37179,=0A    39614,=0A    38922,=
=0A    37728=0A  ],=0A  "interrupts.CPU38.PMI:Performance_monitoring_interr=
upts": [=0A    38134,=0A    38429,=0A    39762,=0A    38946,=0A    38863=0A=
  ],=0A  "interrupts.CPU39.PMI:Performance_monitoring_interrupts": [=0A    =
38166,=0A    36683,=0A    38461,=0A    37859,=0A    39367=0A  ],=0A  "inter=
rupts.CPU40.PMI:Performance_monitoring_interrupts": [=0A    38714,=0A    39=
056,=0A    38480,=0A    38528,=0A    38866=0A  ],=0A  "interrupts.CPU41.PMI=
:Performance_monitoring_interrupts": [=0A    39272,=0A    38137,=0A    3855=
2,=0A    38893,=0A    37588=0A  ],=0A  "interrupts.CPU42.PMI:Performance_mo=
nitoring_interrupts": [=0A    38371,=0A    38026,=0A    39396,=0A    39070,=
=0A    39164=0A  ],=0A  "interrupts.CPU43.PMI:Performance_monitoring_interr=
upts": [=0A    38612,=0A    38662,=0A    39775,=0A    38885,=0A    39400=0A=
  ],=0A  "interrupts.CPU44.PMI:Performance_monitoring_interrupts": [=0A    =
38376,=0A    38389,=0A    38408,=0A    38452,=0A    38620=0A  ],=0A  "inter=
rupts.CPU45.PMI:Performance_monitoring_interrupts": [=0A    37807,=0A    37=
620,=0A    39591,=0A    37845,=0A    38839=0A  ],=0A  "interrupts.CPU46.PMI=
:Performance_monitoring_interrupts": [=0A    38669,=0A    39267,=0A    3880=
5,=0A    38936,=0A    38941=0A  ],=0A  "interrupts.CPU47.PMI:Performance_mo=
nitoring_interrupts": [=0A    38654,=0A    38054,=0A    39895,=0A    38400,=
=0A    38086=0A  ],=0A  "interrupts.PMI:Performance_monitoring_interrupts":=
 [=0A    1869973,=0A    1867431,=0A    1894912,=0A    1877720,=0A    188266=
4=0A  ],=0A  "interrupts.CPU0.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=
=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU1.IWI:IRQ_work_interru=
pts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.=
CPU2.IWI:IRQ_work_interrupts": [=0A    10,=0A    9,=0A    9,=0A    9,=0A   =
 9=0A  ],=0A  "interrupts.CPU3.IWI:IRQ_work_interrupts": [=0A    9,=0A    1=
0,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU4.IWI:IRQ_work_inter=
rupts": [=0A    9,=0A    9,=0A    9,=0A    10,=0A    9=0A  ],=0A  "interrup=
ts.CPU5.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A =
   9=0A  ],=0A  "interrupts.CPU6.IWI:IRQ_work_interrupts": [=0A    9,=0A   =
 9,=0A    9,=0A    9,=0A    10=0A  ],=0A  "interrupts.CPU7.IWI:IRQ_work_int=
errupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interru=
pts.CPU8.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A=
    9=0A  ],=0A  "interrupts.CPU9.IWI:IRQ_work_interrupts": [=0A    9,=0A  =
  9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU10.IWI:IRQ_work_in=
terrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interr=
upts.CPU11.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=
=0A    9=0A  ],=0A  "interrupts.CPU12.IWI:IRQ_work_interrupts": [=0A    9,=
=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU13.IWI:IRQ_wo=
rk_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "i=
nterrupts.CPU14.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A  =
  9,=0A    9=0A  ],=0A  "interrupts.CPU15.IWI:IRQ_work_interrupts": [=0A   =
 9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU16.IWI:IRQ=
_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A =
 "interrupts.CPU17.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    10,=
=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU18.IWI:IRQ_work_interrupts": [=
=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU19.I=
WI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  =
],=0A  "interrupts.CPU20.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A  =
  9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU21.IWI:IRQ_work_interrupts"=
: [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU2=
2.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=
=0A  ],=0A  "interrupts.CPU23.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=
=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU24.IWI:IRQ_work_interr=
upts": [=0A    10,=0A    9,=0A    10,=0A    9,=0A    10=0A  ],=0A  "interru=
pts.CPU25.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=
=0A    9=0A  ],=0A  "interrupts.CPU26.IWI:IRQ_work_interrupts": [=0A    9,=
=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU27.IWI:IRQ_wo=
rk_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "i=
nterrupts.CPU28.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A  =
  10,=0A    9=0A  ],=0A  "interrupts.CPU29.IWI:IRQ_work_interrupts": [=0A  =
  9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU30.IWI:IR=
Q_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A=
  "interrupts.CPU31.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=
=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU32.IWI:IRQ_work_interrupts": [=
=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU33.I=
WI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  =
],=0A  "interrupts.CPU34.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A  =
  9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU35.IWI:IRQ_work_interrupts"=
: [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU3=
6.IWI:IRQ_work_interrupts": [=0A    9,=0A    10,=0A    9,=0A    9,=0A    9=
=0A  ],=0A  "interrupts.CPU37.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=
=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU38.IWI:IRQ_work_interr=
upts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts=
=2ECPU39.IWI:IRQ_work_interrupts": [=0A    9,=0A    8,=0A    9,=0A    9,=0A=
    9=0A  ],=0A  "interrupts.CPU40.IWI:IRQ_work_interrupts": [=0A    9,=0A =
   9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU41.IWI:IRQ_work_i=
nterrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "inter=
rupts.CPU42.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=
=0A    9=0A  ],=0A  "interrupts.CPU43.IWI:IRQ_work_interrupts": [=0A    9,=
=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU44.IWI:IRQ_wo=
rk_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "i=
nterrupts.CPU45.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A  =
  9,=0A    9=0A  ],=0A  "interrupts.CPU46.IWI:IRQ_work_interrupts": [=0A   =
 9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU47.IWI:IRQ=
_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A =
 "interrupts.IWI:IRQ_work_interrupts": [=0A    434,=0A    433,=0A    434,=
=0A    434,=0A    434=0A  ],=0A  "interrupts.CPU0.RTR:APIC_ICR_read_retries=
": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.RTR=
:APIC_ICR_read_retries": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  =
],=0A  "interrupts.CPU0.RES:Rescheduling_interrupts": [=0A    29354,=0A    =
29211,=0A    32926,=0A    25756,=0A    28971=0A  ],=0A  "interrupts.CPU1.RE=
S:Rescheduling_interrupts": [=0A    26062,=0A    25445,=0A    27811,=0A    =
22100,=0A    25279=0A  ],=0A  "interrupts.CPU2.RES:Rescheduling_interrupts"=
: [=0A    25548,=0A    26076,=0A    27369,=0A    20568,=0A    23412=0A  ],=
=0A  "interrupts.CPU3.RES:Rescheduling_interrupts": [=0A    26588,=0A    23=
845,=0A    24902,=0A    19568,=0A    23926=0A  ],=0A  "interrupts.CPU4.RES:=
Rescheduling_interrupts": [=0A    23062,=0A    24792,=0A    26854,=0A    22=
224,=0A    24061=0A  ],=0A  "interrupts.CPU5.RES:Rescheduling_interrupts": =
[=0A    25321,=0A    23567,=0A    28021,=0A    21933,=0A    24838=0A  ],=0A=
  "interrupts.CPU6.RES:Rescheduling_interrupts": [=0A    25987,=0A    24227=
,=0A    26226,=0A    21780,=0A    25665=0A  ],=0A  "interrupts.CPU7.RES:Res=
cheduling_interrupts": [=0A    22569,=0A    23528,=0A    26918,=0A    22981=
,=0A    23521=0A  ],=0A  "interrupts.CPU8.RES:Rescheduling_interrupts": [=
=0A    24446,=0A    25178,=0A    26701,=0A    21053,=0A    25527=0A  ],=0A =
 "interrupts.CPU9.RES:Rescheduling_interrupts": [=0A    23436,=0A    23861,=
=0A    24172,=0A    21682,=0A    24037=0A  ],=0A  "interrupts.CPU10.RES:Res=
cheduling_interrupts": [=0A    23701,=0A    23255,=0A    29217,=0A    20689=
,=0A    23631=0A  ],=0A  "interrupts.CPU11.RES:Rescheduling_interrupts": [=
=0A    25322,=0A    24600,=0A    21644,=0A    20814,=0A    25480=0A  ],=0A =
 "interrupts.CPU12.RES:Rescheduling_interrupts": [=0A    28605,=0A    30766=
,=0A    27490,=0A    30392,=0A    28575=0A  ],=0A  "interrupts.CPU13.RES:Re=
scheduling_interrupts": [=0A    27329,=0A    28339,=0A    28243,=0A    3177=
3,=0A    27837=0A  ],=0A  "interrupts.CPU14.RES:Rescheduling_interrupts": [=
=0A    29247,=0A    28179,=0A    26835,=0A    30914,=0A    28126=0A  ],=0A =
 "interrupts.CPU15.RES:Rescheduling_interrupts": [=0A    26977,=0A    28986=
,=0A    28117,=0A    29078,=0A    28664=0A  ],=0A  "interrupts.CPU16.RES:Re=
scheduling_interrupts": [=0A    32224,=0A    28092,=0A    26821,=0A    2980=
8,=0A    27326=0A  ],=0A  "interrupts.CPU17.RES:Rescheduling_interrupts": [=
=0A    29122,=0A    30876,=0A    25352,=0A    31945,=0A    26857=0A  ],=0A =
 "interrupts.CPU18.RES:Rescheduling_interrupts": [=0A    30241,=0A    32559=
,=0A    25249,=0A    31707,=0A    27519=0A  ],=0A  "interrupts.CPU19.RES:Re=
scheduling_interrupts": [=0A    28308,=0A    28503,=0A    26654,=0A    3288=
0,=0A    30753=0A  ],=0A  "interrupts.CPU20.RES:Rescheduling_interrupts": [=
=0A    30855,=0A    27837,=0A    27447,=0A    29115,=0A    27872=0A  ],=0A =
 "interrupts.CPU21.RES:Rescheduling_interrupts": [=0A    29813,=0A    30305=
,=0A    26879,=0A    30829,=0A    29314=0A  ],=0A  "interrupts.CPU22.RES:Re=
scheduling_interrupts": [=0A    27619,=0A    28435,=0A    27671,=0A    3094=
6,=0A    29219=0A  ],=0A  "interrupts.CPU23.RES:Rescheduling_interrupts": [=
=0A    31604,=0A    28582,=0A    29255,=0A    30611,=0A    28252=0A  ],=0A =
 "interrupts.CPU24.RES:Rescheduling_interrupts": [=0A    22590,=0A    23277=
,=0A    26203,=0A    19285,=0A    16948=0A  ],=0A  "interrupts.CPU25.RES:Re=
scheduling_interrupts": [=0A    23878,=0A    20101,=0A    23027,=0A    1732=
6,=0A    23489=0A  ],=0A  "interrupts.CPU26.RES:Rescheduling_interrupts": [=
=0A    19301,=0A    23712,=0A    24985,=0A    19139,=0A    19891=0A  ],=0A =
 "interrupts.CPU27.RES:Rescheduling_interrupts": [=0A    15811,=0A    20880=
,=0A    23542,=0A    18349,=0A    20126=0A  ],=0A  "interrupts.CPU28.RES:Re=
scheduling_interrupts": [=0A    21806,=0A    22720,=0A    22227,=0A    1960=
2,=0A    21861=0A  ],=0A  "interrupts.CPU29.RES:Rescheduling_interrupts": [=
=0A    19688,=0A    23576,=0A    21761,=0A    19492,=0A    21472=0A  ],=0A =
 "interrupts.CPU30.RES:Rescheduling_interrupts": [=0A    17913,=0A    17669=
,=0A    22141,=0A    16438,=0A    19271=0A  ],=0A  "interrupts.CPU31.RES:Re=
scheduling_interrupts": [=0A    21925,=0A    17916,=0A    20694,=0A    1632=
8,=0A    22548=0A  ],=0A  "interrupts.CPU32.RES:Rescheduling_interrupts": [=
=0A    18664,=0A    20339,=0A    26314,=0A    18815,=0A    19887=0A  ],=0A =
 "interrupts.CPU33.RES:Rescheduling_interrupts": [=0A    19419,=0A    18373=
,=0A    26591,=0A    21379,=0A    23471=0A  ],=0A  "interrupts.CPU34.RES:Re=
scheduling_interrupts": [=0A    21295,=0A    23010,=0A    22669,=0A    1992=
8,=0A    24150=0A  ],=0A  "interrupts.CPU35.RES:Rescheduling_interrupts": [=
=0A    22952,=0A    20403,=0A    22351,=0A    20076,=0A    21670=0A  ],=0A =
 "interrupts.CPU36.RES:Rescheduling_interrupts": [=0A    26362,=0A    28771=
,=0A    21320,=0A    32333,=0A    28694=0A  ],=0A  "interrupts.CPU37.RES:Re=
scheduling_interrupts": [=0A    28931,=0A    29673,=0A    23204,=0A    3284=
7,=0A    29393=0A  ],=0A  "interrupts.CPU38.RES:Rescheduling_interrupts": [=
=0A    30466,=0A    27402,=0A    22441,=0A    31543,=0A    26565=0A  ],=0A =
 "interrupts.CPU39.RES:Rescheduling_interrupts": [=0A    30428,=0A    30120=
,=0A    26517,=0A    33583,=0A    25902=0A  ],=0A  "interrupts.CPU40.RES:Re=
scheduling_interrupts": [=0A    26476,=0A    29725,=0A    29046,=0A    3071=
3,=0A    28247=0A  ],=0A  "interrupts.CPU41.RES:Rescheduling_interrupts": [=
=0A    30134,=0A    28439,=0A    24431,=0A    29803,=0A    29945=0A  ],=0A =
 "interrupts.CPU42.RES:Rescheduling_interrupts": [=0A    28411,=0A    32523=
,=0A    25857,=0A    32228,=0A    28281=0A  ],=0A  "interrupts.CPU43.RES:Re=
scheduling_interrupts": [=0A    32916,=0A    26940,=0A    26156,=0A    3168=
2,=0A    31000=0A  ],=0A  "interrupts.CPU44.RES:Rescheduling_interrupts": [=
=0A    26151,=0A    31144,=0A    26023,=0A    30748,=0A    31102=0A  ],=0A =
 "interrupts.CPU45.RES:Rescheduling_interrupts": [=0A    27052,=0A    23661=
,=0A    25018,=0A    30707,=0A    28987=0A  ],=0A  "interrupts.CPU46.RES:Re=
scheduling_interrupts": [=0A    28066,=0A    27059,=0A    24260,=0A    3157=
7,=0A    28900=0A  ],=0A  "interrupts.CPU47.RES:Rescheduling_interrupts": [=
=0A    26549,=0A    26474,=0A    23797,=0A    32547,=0A    29162=0A  ],=0A =
 "interrupts.RES:Rescheduling_interrupts": [=0A    1240524,=0A    1242951,=
=0A    1229349,=0A    1237614,=0A    1239624=0A  ],=0A  "interrupts.CPU0.CA=
L:Function_call_interrupts": [=0A    165,=0A    219,=0A    120,=0A    189,=
=0A    152=0A  ],=0A  "interrupts.CPU1.CAL:Function_call_interrupts": [=0A =
   152,=0A    189,=0A    110,=0A    175,=0A    143=0A  ],=0A  "interrupts.C=
PU2.CAL:Function_call_interrupts": [=0A    144,=0A    189,=0A    106,=0A   =
 182,=0A    107=0A  ],=0A  "interrupts.CPU3.CAL:Function_call_interrupts": =
[=0A    153,=0A    164,=0A    117,=0A    166,=0A    147=0A  ],=0A  "interru=
pts.CPU4.CAL:Function_call_interrupts": [=0A    142,=0A    184,=0A    115,=
=0A    162,=0A    92=0A  ],=0A  "interrupts.CPU5.CAL:Function_call_interrup=
ts": [=0A    143,=0A    159,=0A    109,=0A    189,=0A    117=0A  ],=0A  "in=
terrupts.CPU6.CAL:Function_call_interrupts": [=0A    140,=0A    204,=0A    =
104,=0A    157,=0A    120=0A  ],=0A  "interrupts.CPU7.CAL:Function_call_int=
errupts": [=0A    140,=0A    157,=0A    86,=0A    146,=0A    100=0A  ],=0A =
 "interrupts.CPU8.CAL:Function_call_interrupts": [=0A    137,=0A    162,=0A=
    117,=0A    149,=0A    113=0A  ],=0A  "interrupts.CPU9.CAL:Function_call=
_interrupts": [=0A    127,=0A    168,=0A    103,=0A    143,=0A    116=0A  ]=
,=0A  "interrupts.CPU10.CAL:Function_call_interrupts": [=0A    139,=0A    1=
65,=0A    94,=0A    175,=0A    131=0A  ],=0A  "interrupts.CPU11.CAL:Functio=
n_call_interrupts": [=0A    150,=0A    155,=0A    115,=0A    154,=0A    133=
=0A  ],=0A  "interrupts.CPU12.CAL:Function_call_interrupts": [=0A    54,=0A=
    60,=0A    71,=0A    92,=0A    65=0A  ],=0A  "interrupts.CPU13.CAL:Funct=
ion_call_interrupts": [=0A    45,=0A    41,=0A    52,=0A    60,=0A    67=0A=
  ],=0A  "interrupts.CPU14.CAL:Function_call_interrupts": [=0A    48,=0A   =
 42,=0A    44,=0A    68,=0A    59=0A  ],=0A  "interrupts.CPU15.CAL:Function=
_call_interrupts": [=0A    46,=0A    41,=0A    58,=0A    66,=0A    51=0A  ]=
,=0A  "interrupts.CPU16.CAL:Function_call_interrupts": [=0A    43,=0A    52=
,=0A    42,=0A    71,=0A    44=0A  ],=0A  "interrupts.CPU17.CAL:Function_ca=
ll_interrupts": [=0A    39,=0A    50,=0A    34,=0A    62,=0A    54=0A  ],=
=0A  "interrupts.CPU18.CAL:Function_call_interrupts": [=0A    45,=0A    43,=
=0A    40,=0A    54,=0A    50=0A  ],=0A  "interrupts.CPU19.CAL:Function_cal=
l_interrupts": [=0A    38,=0A    35,=0A    39,=0A    61,=0A    41=0A  ],=0A=
  "interrupts.CPU20.CAL:Function_call_interrupts": [=0A    41,=0A    38,=0A=
    44,=0A    44,=0A    54=0A  ],=0A  "interrupts.CPU21.CAL:Function_call_i=
nterrupts": [=0A    38,=0A    47,=0A    36,=0A    51,=0A    48=0A  ],=0A  "=
interrupts.CPU22.CAL:Function_call_interrupts": [=0A    34,=0A    37,=0A   =
 37,=0A    53,=0A    46=0A  ],=0A  "interrupts.CPU23.CAL:Function_call_inte=
rrupts": [=0A    32,=0A    43,=0A    34,=0A    37,=0A    47=0A  ],=0A  "int=
errupts.CPU24.CAL:Function_call_interrupts": [=0A    44,=0A    50,=0A    29=
,=0A    45,=0A    41=0A  ],=0A  "interrupts.CPU25.CAL:Function_call_interru=
pts": [=0A    43,=0A    41,=0A    29,=0A    46,=0A    43=0A  ],=0A  "interr=
upts.CPU26.CAL:Function_call_interrupts": [=0A    26,=0A    50,=0A    22,=
=0A    51,=0A    31=0A  ],=0A  "interrupts.CPU27.CAL:Function_call_interrup=
ts": [=0A    34,=0A    39,=0A    26,=0A    46,=0A    40=0A  ],=0A  "interru=
pts.CPU28.CAL:Function_call_interrupts": [=0A    38,=0A    43,=0A    25,=0A=
    45,=0A    35=0A  ],=0A  "interrupts.CPU29.CAL:Function_call_interrupts"=
: [=0A    35,=0A    40,=0A    25,=0A    44,=0A    25=0A  ],=0A  "interrupts=
=2ECPU30.CAL:Function_call_interrupts": [=0A    38,=0A    47,=0A    25,=0A =
   39,=0A    29=0A  ],=0A  "interrupts.CPU31.CAL:Function_call_interrupts":=
 [=0A    31,=0A    39,=0A    26,=0A    39,=0A    41=0A  ],=0A  "interrupts.=
CPU32.CAL:Function_call_interrupts": [=0A    24,=0A    39,=0A    24,=0A    =
43,=0A    38=0A  ],=0A  "interrupts.CPU33.CAL:Function_call_interrupts": [=
=0A    26,=0A    43,=0A    23,=0A    48,=0A    39=0A  ],=0A  "interrupts.CP=
U34.CAL:Function_call_interrupts": [=0A    34,=0A    62,=0A    23,=0A    41=
,=0A    36=0A  ],=0A  "interrupts.CPU35.CAL:Function_call_interrupts": [=0A=
    38,=0A    48,=0A    26,=0A    42,=0A    28=0A  ],=0A  "interrupts.CPU36=
=2ECAL:Function_call_interrupts": [=0A    6,=0A    6,=0A    6,=0A    6,=0A =
   6=0A  ],=0A  "interrupts.CPU37.CAL:Function_call_interrupts": [=0A    6,=
=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU38.CAL:Functi=
on_call_interrupts": [=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=
=0A  "interrupts.CPU39.CAL:Function_call_interrupts": [=0A    6,=0A    6,=
=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU40.CAL:Function_call_i=
nterrupts": [=0A    3,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "inter=
rupts.CPU41.CAL:Function_call_interrupts": [=0A    6,=0A    6,=0A    6,=0A =
   6,=0A    6=0A  ],=0A  "interrupts.CPU42.CAL:Function_call_interrupts": [=
=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU43.C=
AL:Function_call_interrupts": [=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=
=0A  ],=0A  "interrupts.CPU44.CAL:Function_call_interrupts": [=0A    6,=0A =
   6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU45.CAL:Function_c=
all_interrupts": [=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "=
interrupts.CPU46.CAL:Function_call_interrupts": [=0A    6,=0A    6,=0A    6=
,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU47.CAL:Function_call_interrupt=
s": [=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CA=
L:Function_call_interrupts": [=0A    2715,=0A    3257,=0A    2202,=0A    33=
07,=0A    2595=0A  ],=0A  "interrupts.CPU0.TLB:TLB_shootdowns": [=0A    363=
76,=0A    43419,=0A    27067,=0A    44912,=0A    32078=0A  ],=0A  "interrup=
ts.CPU1.TLB:TLB_shootdowns": [=0A    35880,=0A    43724,=0A    26916,=0A   =
 44808,=0A    31689=0A  ],=0A  "interrupts.CPU2.TLB:TLB_shootdowns": [=0A  =
  35855,=0A    43198,=0A    26852,=0A    44914,=0A    32023=0A  ],=0A  "int=
errupts.CPU3.TLB:TLB_shootdowns": [=0A    35723,=0A    43865,=0A    26890,=
=0A    45088,=0A    31824=0A  ],=0A  "interrupts.CPU4.TLB:TLB_shootdowns": =
[=0A    35994,=0A    43150,=0A    26847,=0A    44745,=0A    32179=0A  ],=0A=
  "interrupts.CPU5.TLB:TLB_shootdowns": [=0A    35805,=0A    43350,=0A    2=
7037,=0A    44686,=0A    31814=0A  ],=0A  "interrupts.CPU6.TLB:TLB_shootdow=
ns": [=0A    35721,=0A    42872,=0A    26918,=0A    45058,=0A    31931=0A  =
],=0A  "interrupts.CPU7.TLB:TLB_shootdowns": [=0A    35937,=0A    43519,=0A=
    26632,=0A    44361,=0A    32089=0A  ],=0A  "interrupts.CPU8.TLB:TLB_sho=
otdowns": [=0A    35892,=0A    43356,=0A    26757,=0A    44833,=0A    31913=
=0A  ],=0A  "interrupts.CPU9.TLB:TLB_shootdowns": [=0A    35813,=0A    4309=
6,=0A    27374,=0A    45015,=0A    32095=0A  ],=0A  "interrupts.CPU10.TLB:T=
LB_shootdowns": [=0A    36025,=0A    43479,=0A    26795,=0A    44590,=0A   =
 32114=0A  ],=0A  "interrupts.CPU11.TLB:TLB_shootdowns": [=0A    35742,=0A =
   43411,=0A    27318,=0A    45022,=0A    31966=0A  ],=0A  "interrupts.CPU1=
2.TLB:TLB_shootdowns": [=0A    35619,=0A    42347,=0A    26832,=0A    43573=
,=0A    30847=0A  ],=0A  "interrupts.CPU13.TLB:TLB_shootdowns": [=0A    356=
47,=0A    42535,=0A    26956,=0A    43481,=0A    30932=0A  ],=0A  "interrup=
ts.CPU14.TLB:TLB_shootdowns": [=0A    35616,=0A    42846,=0A    27090,=0A  =
  44475,=0A    31171=0A  ],=0A  "interrupts.CPU15.TLB:TLB_shootdowns": [=0A=
    35778,=0A    43027,=0A    26731,=0A    43446,=0A    31157=0A  ],=0A  "i=
nterrupts.CPU16.TLB:TLB_shootdowns": [=0A    35255,=0A    42387,=0A    2663=
0,=0A    43545,=0A    31278=0A  ],=0A  "interrupts.CPU17.TLB:TLB_shootdowns=
": [=0A    35318,=0A    42080,=0A    27043,=0A    43102,=0A    31332=0A  ],=
=0A  "interrupts.CPU18.TLB:TLB_shootdowns": [=0A    35517,=0A    42281,=0A =
   26913,=0A    43350,=0A    31231=0A  ],=0A  "interrupts.CPU19.TLB:TLB_sho=
otdowns": [=0A    35513,=0A    42724,=0A    26614,=0A    43274,=0A    30730=
=0A  ],=0A  "interrupts.CPU20.TLB:TLB_shootdowns": [=0A    35518,=0A    430=
99,=0A    26862,=0A    43496,=0A    31092=0A  ],=0A  "interrupts.CPU21.TLB:=
TLB_shootdowns": [=0A    35327,=0A    42124,=0A    26624,=0A    43322,=0A  =
  30670=0A  ],=0A  "interrupts.CPU22.TLB:TLB_shootdowns": [=0A    35409,=0A=
    42538,=0A    26380,=0A    43371,=0A    30806=0A  ],=0A  "interrupts.CPU=
23.TLB:TLB_shootdowns": [=0A    35420,=0A    42598,=0A    26516,=0A    4298=
1,=0A    31072=0A  ],=0A  "interrupts.CPU24.TLB:TLB_shootdowns": [=0A    35=
843,=0A    43641,=0A    27010,=0A    44966,=0A    32257=0A  ],=0A  "interru=
pts.CPU25.TLB:TLB_shootdowns": [=0A    36202,=0A    43918,=0A    27179,=0A =
   45296,=0A    31957=0A  ],=0A  "interrupts.CPU26.TLB:TLB_shootdowns": [=
=0A    36258,=0A    43209,=0A    26795,=0A    45145,=0A    32033=0A  ],=0A =
 "interrupts.CPU27.TLB:TLB_shootdowns": [=0A    36406,=0A    43877,=0A    2=
7298,=0A    45532,=0A    32107=0A  ],=0A  "interrupts.CPU28.TLB:TLB_shootdo=
wns": [=0A    35656,=0A    43449,=0A    27113,=0A    45219,=0A    31856=0A =
 ],=0A  "interrupts.CPU29.TLB:TLB_shootdowns": [=0A    35917,=0A    43405,=
=0A    26957,=0A    45420,=0A    32309=0A  ],=0A  "interrupts.CPU30.TLB:TLB=
_shootdowns": [=0A    36206,=0A    43671,=0A    27055,=0A    45180,=0A    3=
2029=0A  ],=0A  "interrupts.CPU31.TLB:TLB_shootdowns": [=0A    36012,=0A   =
 43920,=0A    27239,=0A    45631,=0A    31885=0A  ],=0A  "interrupts.CPU32.=
TLB:TLB_shootdowns": [=0A    36672,=0A    43706,=0A    27148,=0A    45265,=
=0A    32151=0A  ],=0A  "interrupts.CPU33.TLB:TLB_shootdowns": [=0A    3647=
6,=0A    44257,=0A    26843,=0A    44968,=0A    32115=0A  ],=0A  "interrupt=
s.CPU34.TLB:TLB_shootdowns": [=0A    36239,=0A    43320,=0A    27274,=0A   =
 45266,=0A    31796=0A  ],=0A  "interrupts.CPU35.TLB:TLB_shootdowns": [=0A =
   35754,=0A    43414,=0A    27013,=0A    44762,=0A    31866=0A  ],=0A  "in=
terrupts.CPU36.TLB:TLB_shootdowns": [=0A    35752,=0A    42100,=0A    27347=
,=0A    42562,=0A    30311=0A  ],=0A  "interrupts.CPU37.TLB:TLB_shootdowns"=
: [=0A    35263,=0A    42102,=0A    26846,=0A    43282,=0A    30969=0A  ],=
=0A  "interrupts.CPU38.TLB:TLB_shootdowns": [=0A    35204,=0A    42764,=0A =
   26785,=0A    42277,=0A    30627=0A  ],=0A  "interrupts.CPU39.TLB:TLB_sho=
otdowns": [=0A    34840,=0A    42704,=0A    26584,=0A    41981,=0A    31032=
=0A  ],=0A  "interrupts.CPU40.TLB:TLB_shootdowns": [=0A    35388,=0A    419=
63,=0A    26568,=0A    42587,=0A    30510=0A  ],=0A  "interrupts.CPU41.TLB:=
TLB_shootdowns": [=0A    35161,=0A    42271,=0A    26792,=0A    42797,=0A  =
  30260=0A  ],=0A  "interrupts.CPU42.TLB:TLB_shootdowns": [=0A    35374,=0A=
    41328,=0A    26538,=0A    42483,=0A    30358=0A  ],=0A  "interrupts.CPU=
43.TLB:TLB_shootdowns": [=0A    34605,=0A    42240,=0A    26787,=0A    4215=
4,=0A    30531=0A  ],=0A  "interrupts.CPU44.TLB:TLB_shootdowns": [=0A    35=
511,=0A    41596,=0A    26609,=0A    42299,=0A    30212=0A  ],=0A  "interru=
pts.CPU45.TLB:TLB_shootdowns": [=0A    35483,=0A    42680,=0A    26850,=0A =
   42547,=0A    30387=0A  ],=0A  "interrupts.CPU46.TLB:TLB_shootdowns": [=
=0A    35201,=0A    42418,=0A    26782,=0A    42042,=0A    30306=0A  ],=0A =
 "interrupts.CPU47.TLB:TLB_shootdowns": [=0A    35000,=0A    42091,=0A    2=
6472,=0A    42171,=0A    30516=0A  ],=0A  "interrupts.TLB:TLB_shootdowns": =
[=0A    1713123,=0A    2061069,=0A    1290478,=0A    2111280,=0A    1506413=
=0A  ],=0A  "interrupts.CPU0.MCP:Machine_check_polls": [=0A    2,=0A    2,=
=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU1.MCP:Machine_check_po=
lls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.=
CPU2.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    =
2=0A  ],=0A  "interrupts.CPU3.MCP:Machine_check_polls": [=0A    2,=0A    2,=
=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU4.MCP:Machine_check_po=
lls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.=
CPU5.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    =
2=0A  ],=0A  "interrupts.CPU6.MCP:Machine_check_polls": [=0A    2,=0A    2,=
=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU7.MCP:Machine_check_po=
lls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.=
CPU8.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    =
2=0A  ],=0A  "interrupts.CPU9.MCP:Machine_check_polls": [=0A    2,=0A    2,=
=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU10.MCP:Machine_check_p=
olls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts=
=2ECPU11.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A=
    2=0A  ],=0A  "interrupts.CPU12.MCP:Machine_check_polls": [=0A    2,=0A =
   2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU13.MCP:Machine_ch=
eck_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "inter=
rupts.CPU14.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=
=0A    2=0A  ],=0A  "interrupts.CPU15.MCP:Machine_check_polls": [=0A    2,=
=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU16.MCP:Machin=
e_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "i=
nterrupts.CPU17.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A  =
  2,=0A    2=0A  ],=0A  "interrupts.CPU18.MCP:Machine_check_polls": [=0A   =
 2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU19.MCP:Mac=
hine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A =
 "interrupts.CPU20.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=
=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU21.MCP:Machine_check_polls": [=
=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU22.M=
CP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  =
],=0A  "interrupts.CPU23.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A  =
  2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU24.MCP:Machine_check_polls"=
: [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU2=
5.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=
=0A  ],=0A  "interrupts.CPU26.MCP:Machine_check_polls": [=0A    2,=0A    2,=
=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU27.MCP:Machine_check_p=
olls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts=
=2ECPU28.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A=
    2=0A  ],=0A  "interrupts.CPU29.MCP:Machine_check_polls": [=0A    2,=0A =
   2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU30.MCP:Machine_ch=
eck_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "inter=
rupts.CPU31.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=
=0A    2=0A  ],=0A  "interrupts.CPU32.MCP:Machine_check_polls": [=0A    2,=
=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU33.MCP:Machin=
e_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "i=
nterrupts.CPU34.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A  =
  2,=0A    2=0A  ],=0A  "interrupts.CPU35.MCP:Machine_check_polls": [=0A   =
 2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU36.MCP:Mac=
hine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A =
 "interrupts.CPU37.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=
=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU38.MCP:Machine_check_polls": [=
=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU39.M=
CP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  =
],=0A  "interrupts.CPU40.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A  =
  2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU41.MCP:Machine_check_polls"=
: [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU4=
2.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=
=0A  ],=0A  "interrupts.CPU43.MCP:Machine_check_polls": [=0A    2,=0A    2,=
=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU44.MCP:Machine_check_p=
olls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts=
=2ECPU45.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A=
    2=0A  ],=0A  "interrupts.CPU46.MCP:Machine_check_polls": [=0A    2,=0A =
   2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU47.MCP:Machine_ch=
eck_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "inter=
rupts.MCP:Machine_check_polls": [=0A    96,=0A    96,=0A    96,=0A    96,=
=0A    96=0A  ],=0A  "numa-numastat.node0.numa_hit": [=0A    449883523,=0A =
   449640633,=0A    458398503,=0A    445778896,=0A    455773229=0A  ],=0A  =
"numa-numastat.node0.interleave_hit": [=0A    0,=0A    0,=0A    0,=0A    0,=
=0A    0=0A  ],=0A  "numa-numastat.node0.local_node": [=0A    449882938,=0A=
    449633410,=0A    458397980,=0A    445777731,=0A    455766138=0A  ],=0A =
 "numa-numastat.node0.other_node": [=0A    585,=0A    7223,=0A    523,=0A  =
  1165,=0A    7091=0A  ],=0A  "numa-numastat.node1.numa_hit": [=0A    44942=
7950,=0A    450935283,=0A    446308419,=0A    449073853,=0A    442623182=0A=
  ],=0A  "numa-numastat.node1.interleave_hit": [=0A    0,=0A    0,=0A    0,=
=0A    0,=0A    0=0A  ],=0A  "numa-numastat.node1.local_node": [=0A    4494=
21592,=0A    450935260,=0A    446302060,=0A    449067496,=0A    442623155=
=0A  ],=0A  "numa-numastat.node1.other_node": [=0A    6358,=0A    23,=0A   =
 6359,=0A    6357,=0A    27=0A  ],=0A  "vmstat.procs.r": [=0A    48,=0A    =
49,=0A    49,=0A    48,=0A    49=0A  ],=0A  "vmstat.procs.b": [=0A    0,=0A=
    0,=0A    0,=0A    1,=0A    0=0A  ],=0A  "vmstat.memory.free": [=0A    6=
3489534,=0A    63486185,=0A    63483960,=0A    63484269,=0A    63485242=0A =
 ],=0A  "vmstat.memory.cache": [=0A    1683704,=0A    1685831,=0A    168779=
0,=0A    1686508,=0A    1686712=0A  ],=0A  "vmstat.system.in": [=0A    5629=
5,=0A    56629,=0A    55901,=0A    56721,=0A    56133=0A  ],=0A  "vmstat.sy=
stem.cs": [=0A    9335,=0A    10305,=0A    8097,=0A    10414,=0A    8746=0A=
  ],=0A  "vmstat.cpu.us": [=0A    26,=0A    25,=0A    26,=0A    25,=0A    2=
6=0A  ],=0A  "vmstat.cpu.sy": [=0A    71,=0A    71,=0A    71,=0A    71,=0A =
   71=0A  ],=0A  "vmstat.cpu.id": [=0A    1,=0A    2,=0A    1,=0A    1,=0A =
   1=0A  ],=0A  "vmstat.cpu.wa": [=0A    0,=0A    0,=0A    0,=0A    0,=0A  =
  0=0A  ],=0A  "proc-vmstat.nr_free_pages": [=0A    15871772,=0A    1587141=
4,=0A    15870891,=0A    15870861,=0A    15871250=0A  ],=0A  "proc-vmstat.n=
r_alloc_batch": [=0A    3383,=0A    3259,=0A    3368,=0A    3381,=0A    331=
6=0A  ],=0A  "proc-vmstat.nr_inactive_anon": [=0A    1116,=0A    1127,=0A  =
  1176,=0A    1134,=0A    1175=0A  ],=0A  "proc-vmstat.nr_active_anon": [=
=0A    58372,=0A    58530,=0A    59066,=0A    58794,=0A    58756=0A  ],=0A =
 "proc-vmstat.nr_inactive_file": [=0A    294659,=0A    295011,=0A    294872=
,=0A    294646,=0A    294685=0A  ],=0A  "proc-vmstat.nr_active_file": [=0A =
   75799,=0A    75443,=0A    75367,=0A    75749,=0A    75438=0A  ],=0A  "pr=
oc-vmstat.nr_anon_pages": [=0A    8524,=0A    8553,=0A    8461,=0A    8551,=
=0A    8555=0A  ],=0A  "proc-vmstat.nr_mapped": [=0A    2847,=0A    2805,=
=0A    2895,=0A    2809,=0A    2893=0A  ],=0A  "proc-vmstat.nr_file_pages":=
 [=0A    421476,=0A    421558,=0A    422113,=0A    421769,=0A    421585=0A =
 ],=0A  "proc-vmstat.nr_dirty": [=0A    3,=0A    3,=0A    3,=0A    3,=0A   =
 3=0A  ],=0A  "proc-vmstat.nr_writeback": [=0A    0,=0A    0,=0A    0,=0A  =
  0,=0A    0=0A  ],=0A  "proc-vmstat.nr_slab_reclaimable": [=0A    18462,=
=0A    18621,=0A    18681,=0A    18582,=0A    18585=0A  ],=0A  "proc-vmstat=
=2Enr_slab_unreclaimable": [=0A    28154,=0A    28219,=0A    28285,=0A    2=
8317,=0A    28358=0A  ],=0A  "proc-vmstat.nr_page_table_pages": [=0A    109=
7,=0A    1098,=0A    1096,=0A    1105,=0A    1048=0A  ],=0A  "proc-vmstat.n=
r_kernel_stack": [=0A    1125,=0A    1126,=0A    1126,=0A    1126,=0A    11=
26=0A  ],=0A  "proc-vmstat.nr_isolated_anon": [=0A    0,=0A    0,=0A    0,=
=0A    0,=0A    0=0A  ],=0A  "proc-vmstat.nr_shmem": [=0A    50966,=0A    5=
1105,=0A    51784,=0A    51377,=0A    51378=0A  ],=0A  "proc-vmstat.nr_dirt=
ied": [=0A    175,=0A    175,=0A    135,=0A    145,=0A    176=0A  ],=0A  "p=
roc-vmstat.nr_written": [=0A    172,=0A    170,=0A    100,=0A    170,=0A   =
 143=0A  ],=0A  "proc-vmstat.numa_hit": [=0A    899301799,=0A    900549021,=
=0A    904699209,=0A    894830894,=0A    898389891=0A  ],=0A  "proc-vmstat.=
numa_interleave": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  =
"proc-vmstat.numa_local": [=0A    899294856,=0A    900541775,=0A    9046923=
27,=0A    894823372,=0A    898382773=0A  ],=0A  "proc-vmstat.numa_other": [=
=0A    6943,=0A    7246,=0A    6882,=0A    7522,=0A    7118=0A  ],=0A  "pro=
c-vmstat.nr_anon_transparent_hugepages": [=0A    1,=0A    0,=0A    1,=0A   =
 1,=0A    1=0A  ],=0A  "proc-vmstat.nr_dirty_threshold": [=0A    3235062,=
=0A    3234993,=0A    3234845,=0A    3234867,=0A    3234894=0A  ],=0A  "pro=
c-vmstat.nr_dirty_background_threshold": [=0A    1617531,=0A    1617496,=0A=
    1617422,=0A    1617433,=0A    1617447=0A  ],=0A  "proc-vmstat.pgalloc_d=
ma32": [=0A    14,=0A    18,=0A    12,=0A    39,=0A    12=0A  ],=0A  "proc-=
vmstat.pgalloc_normal": [=0A    936666093,=0A    938453930,=0A    942107999=
,=0A    932188128,=0A    935233938=0A  ],=0A  "proc-vmstat.pgfree": [=0A   =
 936600506,=0A    938388538,=0A    942042047,=0A    932123083,=0A    935168=
250=0A  ],=0A  "proc-vmstat.pgactivate": [=0A    21305493,=0A    21332514,=
=0A    21436118,=0A    21198506,=0A    21287174=0A  ],=0A  "proc-vmstat.pgf=
ault": [=0A    3885798,=0A    4230870,=0A    3456215,=0A    4246540,=0A    =
3673355=0A  ],=0A  "proc-vmstat.pageoutrun": [=0A    0,=0A    0,=0A    0,=
=0A    0,=0A    0=0A  ],=0A  "proc-vmstat.numa_pte_updates": [=0A    491079=
,=0A    538975,=0A    471235,=0A    516824,=0A    474186=0A  ],=0A  "proc-v=
mstat.numa_hint_faults": [=0A    492807,=0A    538409,=0A    471222,=0A    =
516340,=0A    473719=0A  ],=0A  "proc-vmstat.numa_hint_faults_local": [=0A =
   458552,=0A    499315,=0A    437598,=0A    476925,=0A    439128=0A  ],=0A=
  "proc-vmstat.numa_pages_migrated": [=0A    1832,=0A    2308,=0A    1507,=
=0A    1752,=0A    1686=0A  ],=0A  "proc-vmstat.pgmigrate_success": [=0A   =
 1832,=0A    2308,=0A    1507,=0A    1752,=0A    1686=0A  ],=0A  "proc-vmst=
at.thp_fault_alloc": [=0A    1,=0A    0,=0A    0,=0A    0,=0A    1=0A  ],=
=0A  "proc-vmstat.thp_collapse_alloc": [=0A    2,=0A    1,=0A    2,=0A    2=
,=0A    1=0A  ],=0A  "meminfo.MemTotal": [=0A    65869268,=0A    65869268,=
=0A    65869268,=0A    65869268,=0A    65869268=0A  ],=0A  "meminfo.MemFree=
": [=0A    63486376,=0A    63485455,=0A    63482289,=0A    63482959,=0A    =
63484860=0A  ],=0A  "meminfo.MemAvailable": [=0A    64780400,=0A    6477950=
9,=0A    64776439,=0A    64777151,=0A    64778144=0A  ],=0A  "meminfo.Cache=
d": [=0A    1686450,=0A    1686552,=0A    1689536,=0A    1687670,=0A    168=
6995=0A  ],=0A  "meminfo.Active": [=0A    536534,=0A    535916,=0A    53780=
3,=0A    538283,=0A    536673=0A  ],=0A  "meminfo.Inactive": [=0A    118370=
1,=0A    1184889,=0A    1185206,=0A    1183727,=0A    1184328=0A  ],=0A  "m=
eminfo.Active(anon)": [=0A    233491,=0A    234170,=0A    236269,=0A    235=
227,=0A    234990=0A  ],=0A  "meminfo.Inactive(anon)": [=0A    4463,=0A    =
4516,=0A    4707,=0A    4515,=0A    4562=0A  ],=0A  "meminfo.Active(file)":=
 [=0A    303042,=0A    301746,=0A    301534,=0A    303055,=0A    301683=0A =
 ],=0A  "meminfo.Inactive(file)": [=0A    1179237,=0A    1180372,=0A    118=
0498,=0A    1179212,=0A    1179765=0A  ],=0A  "meminfo.Dirty": [=0A    14,=
=0A    14,=0A    14,=0A    14,=0A    14=0A  ],=0A  "meminfo.Writeback": [=
=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "meminfo.AnonPages"=
: [=0A    34098,=0A    34213,=0A    33839,=0A    34207,=0A    34231=0A  ],=
=0A  "meminfo.Mapped": [=0A    11388,=0A    11223,=0A    11627,=0A    11237=
,=0A    11388=0A  ],=0A  "meminfo.Shmem": [=0A    203862,=0A    204480,=0A =
   207141,=0A    205537,=0A    205332=0A  ],=0A  "meminfo.Slab": [=0A    18=
6707,=0A    187096,=0A    188060,=0A    187507,=0A    187397=0A  ],=0A  "me=
minfo.SReclaimable": [=0A    73982,=0A    74366,=0A    74731,=0A    74346,=
=0A    74165=0A  ],=0A  "meminfo.SUnreclaim": [=0A    112724,=0A    112730,=
=0A    113328,=0A    113161,=0A    113231=0A  ],=0A  "meminfo.KernelStack":=
 [=0A    18012,=0A    18015,=0A    18014,=0A    18015,=0A    18021=0A  ],=
=0A  "meminfo.PageTables": [=0A    4390,=0A    4388,=0A    4384,=0A    4422=
,=0A    4195=0A  ],=0A  "meminfo.CommitLimit": [=0A    32934632,=0A    3293=
4632,=0A    32934632,=0A    32934632,=0A    32934632=0A  ],=0A  "meminfo.Co=
mmitted_AS": [=0A    289229,=0A    290096,=0A    289224,=0A    298685,=0A  =
  287745=0A  ],=0A  "meminfo.VmallocTotal": [=0A    34359738367,=0A    3435=
9738367,=0A    34359738367,=0A    34359738367,=0A    34359738367=0A  ],=0A =
 "meminfo.VmallocUsed": [=0A    414936,=0A    414936,=0A    414936,=0A    4=
14936,=0A    414936=0A  ],=0A  "meminfo.VmallocChunk": [=0A    34325786620,=
=0A    34325787132,=0A    34325786620,=0A    34325786620,=0A    34325777400=
=0A  ],=0A  "meminfo.AnonHugePages": [=0A    3699,=0A    2019,=0A    4037,=
=0A    4038,=0A    2050=0A  ],=0A  "meminfo.Hugepagesize": [=0A    2048,=0A=
    2048,=0A    2048,=0A    2048,=0A    2048=0A  ],=0A  "meminfo.DirectMap4=
k": [=0A    87860,=0A    83764,=0A    81716,=0A    87860,=0A    77620=0A  ]=
,=0A  "meminfo.DirectMap2M": [=0A    6123520,=0A    6127616,=0A    6129664,=
=0A    6123520,=0A    6133760=0A  ],=0A  "meminfo.DirectMap1G": [=0A    629=
14560,=0A    62914560,=0A    62914560,=0A    62914560,=0A    62914560=0A  ]=
,=0A  "slabinfo.RAWv6.active_objs": [=0A    270,=0A    270,=0A    270,=0A  =
  270,=0A    270=0A  ],=0A  "slabinfo.RAWv6.num_objs": [=0A    270,=0A    2=
70,=0A    270,=0A    270,=0A    270=0A  ],=0A  "slabinfo.RAWv6.active_slabs=
": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "slabinfo.RAWv6=
=2Enum_slabs": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "sl=
abinfo.UDPv6.active_objs": [=0A    150,=0A    180,=0A    180,=0A    150,=0A=
    150=0A  ],=0A  "slabinfo.UDPv6.num_objs": [=0A    150,=0A    180,=0A   =
 180,=0A    150,=0A    150=0A  ],=0A  "slabinfo.UDPv6.active_slabs": [=0A  =
  5,=0A    6,=0A    6,=0A    5,=0A    5=0A  ],=0A  "slabinfo.UDPv6.num_slab=
s": [=0A    5,=0A    6,=0A    6,=0A    5,=0A    5=0A  ],=0A  "slabinfo.TCPv=
6.active_objs": [=0A    48,=0A    48,=0A    48,=0A    48,=0A    48=0A  ],=
=0A  "slabinfo.TCPv6.num_objs": [=0A    48,=0A    48,=0A    48,=0A    48,=
=0A    48=0A  ],=0A  "slabinfo.TCPv6.active_slabs": [=0A    3,=0A    3,=0A =
   3,=0A    3,=0A    3=0A  ],=0A  "slabinfo.TCPv6.num_slabs": [=0A    3,=0A=
    3,=0A    3,=0A    3,=0A    3=0A  ],=0A  "slabinfo.mqueue_inode_cache.ac=
tive_objs": [=0A    36,=0A    36,=0A    36,=0A    36,=0A    36=0A  ],=0A  "=
slabinfo.mqueue_inode_cache.num_objs": [=0A    36,=0A    36,=0A    36,=0A  =
  36,=0A    36=0A  ],=0A  "slabinfo.mqueue_inode_cache.active_slabs": [=0A =
   1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.mqueue_inode_=
cache.num_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  =
"slabinfo.xfs_buf.active_objs": [=0A    126,=0A    168,=0A    126,=0A    16=
8,=0A    168=0A  ],=0A  "slabinfo.xfs_buf.num_objs": [=0A    126,=0A    168=
,=0A    126,=0A    168,=0A    168=0A  ],=0A  "slabinfo.xfs_buf.active_slabs=
": [=0A    3,=0A    4,=0A    3,=0A    4,=0A    4=0A  ],=0A  "slabinfo.xfs_b=
uf.num_slabs": [=0A    3,=0A    4,=0A    3,=0A    4,=0A    4=0A  ],=0A  "sl=
abinfo.nfs_commit_data.active_objs": [=0A    46,=0A    46,=0A    46,=0A    =
46,=0A    46=0A  ],=0A  "slabinfo.nfs_commit_data.num_objs": [=0A    46,=0A=
    46,=0A    46,=0A    46,=0A    46=0A  ],=0A  "slabinfo.nfs_commit_data.a=
ctive_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "sla=
binfo.nfs_commit_data.num_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A =
   1=0A  ],=0A  "slabinfo.nfs_read_data.active_objs": [=0A    266,=0A    40=
1,=0A    275,=0A    229,=0A    323=0A  ],=0A  "slabinfo.nfs_read_data.num_o=
bjs": [=0A    266,=0A    401,=0A    275,=0A    229,=0A    323=0A  ],=0A  "s=
labinfo.nfs_read_data.active_slabs": [=0A    7,=0A    11,=0A    8,=0A    6,=
=0A    9=0A  ],=0A  "slabinfo.nfs_read_data.num_slabs": [=0A    7,=0A    11=
,=0A    8,=0A    6,=0A    9=0A  ],=0A  "slabinfo.nfs_inode_cache.active_obj=
s": [=0A    31,=0A    31,=0A    31,=0A    31,=0A    62=0A  ],=0A  "slabinfo=
=2Enfs_inode_cache.num_objs": [=0A    31,=0A    31,=0A    31,=0A    31,=0A =
   62=0A  ],=0A  "slabinfo.nfs_inode_cache.active_slabs": [=0A    1,=0A    =
1,=0A    1,=0A    1,=0A    2=0A  ],=0A  "slabinfo.nfs_inode_cache.num_slabs=
": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    2=0A  ],=0A  "slabinfo.huget=
lbfs_inode_cache.active_objs": [=0A    54,=0A    54,=0A    54,=0A    54,=0A=
    54=0A  ],=0A  "slabinfo.hugetlbfs_inode_cache.num_objs": [=0A    54,=0A=
    54,=0A    54,=0A    54,=0A    54=0A  ],=0A  "slabinfo.hugetlbfs_inode_c=
ache.active_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A=
  "slabinfo.hugetlbfs_inode_cache.num_slabs": [=0A    1,=0A    1,=0A    1,=
=0A    1,=0A    1=0A  ],=0A  "slabinfo.posix_timers_cache.active_objs": [=
=0A    56,=0A    56,=0A    56,=0A    56,=0A    56=0A  ],=0A  "slabinfo.posi=
x_timers_cache.num_objs": [=0A    56,=0A    56,=0A    56,=0A    56,=0A    5=
6=0A  ],=0A  "slabinfo.posix_timers_cache.active_slabs": [=0A    0,=0A    0=
,=0A    0,=0A    0,=0A    0=0A  ],=0A  "slabinfo.posix_timers_cache.num_sla=
bs": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "slabinfo.ip_=
fib_trie.active_objs": [=0A    146,=0A    146,=0A    73,=0A    146,=0A    1=
46=0A  ],=0A  "slabinfo.ip_fib_trie.num_objs": [=0A    146,=0A    146,=0A  =
  73,=0A    146,=0A    146=0A  ],=0A  "slabinfo.ip_fib_trie.active_slabs": =
[=0A    2,=0A    2,=0A    1,=0A    2,=0A    2=0A  ],=0A  "slabinfo.ip_fib_t=
rie.num_slabs": [=0A    2,=0A    2,=0A    1,=0A    2,=0A    2=0A  ],=0A  "s=
labinfo.RAW.active_objs": [=0A    612,=0A    612,=0A    792,=0A    612,=0A =
   576=0A  ],=0A  "slabinfo.RAW.num_objs": [=0A    612,=0A    612,=0A    79=
2,=0A    612,=0A    576=0A  ],=0A  "slabinfo.RAW.active_slabs": [=0A    17,=
=0A    17,=0A    22,=0A    17,=0A    16=0A  ],=0A  "slabinfo.RAW.num_slabs"=
: [=0A    17,=0A    17,=0A    22,=0A    17,=0A    16=0A  ],=0A  "slabinfo.U=
DP.active_objs": [=0A    136,=0A    170,=0A    204,=0A    204,=0A    170=0A=
  ],=0A  "slabinfo.UDP.num_objs": [=0A    136,=0A    170,=0A    204,=0A    =
204,=0A    170=0A  ],=0A  "slabinfo.UDP.active_slabs": [=0A    4,=0A    5,=
=0A    6,=0A    6,=0A    5=0A  ],=0A  "slabinfo.UDP.num_slabs": [=0A    4,=
=0A    5,=0A    6,=0A    6,=0A    5=0A  ],=0A  "slabinfo.tw_sock_TCP.active=
_objs": [=0A    64,=0A    64,=0A    64,=0A    64,=0A    64=0A  ],=0A  "slab=
info.tw_sock_TCP.num_objs": [=0A    64,=0A    64,=0A    64,=0A    64,=0A   =
 64=0A  ],=0A  "slabinfo.tw_sock_TCP.active_slabs": [=0A    1,=0A    1,=0A =
   1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.tw_sock_TCP.num_slabs": [=0A   =
 1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.TCP.active_objs=
": [=0A    119,=0A    119,=0A    136,=0A    119,=0A    119=0A  ],=0A  "slab=
info.TCP.num_objs": [=0A    119,=0A    119,=0A    136,=0A    119,=0A    119=
=0A  ],=0A  "slabinfo.TCP.active_slabs": [=0A    7,=0A    7,=0A    8,=0A   =
 7,=0A    7=0A  ],=0A  "slabinfo.TCP.num_slabs": [=0A    7,=0A    7,=0A    =
8,=0A    7,=0A    7=0A  ],=0A  "slabinfo.blkdev_ioc.active_objs": [=0A    3=
9,=0A    39,=0A    39,=0A    39,=0A    39=0A  ],=0A  "slabinfo.blkdev_ioc.n=
um_objs": [=0A    39,=0A    39,=0A    39,=0A    39,=0A    39=0A  ],=0A  "sl=
abinfo.blkdev_ioc.active_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A  =
  1=0A  ],=0A  "slabinfo.blkdev_ioc.num_slabs": [=0A    1,=0A    1,=0A    1=
,=0A    1,=0A    1=0A  ],=0A  "slabinfo.sock_inode_cache.active_objs": [=0A=
    1479,=0A    1581,=0A    1581,=0A    1581,=0A    1377=0A  ],=0A  "slabin=
fo.sock_inode_cache.num_objs": [=0A    1479,=0A    1581,=0A    1581,=0A    =
1581,=0A    1377=0A  ],=0A  "slabinfo.sock_inode_cache.active_slabs": [=0A =
   29,=0A    31,=0A    31,=0A    31,=0A    27=0A  ],=0A  "slabinfo.sock_ino=
de_cache.num_slabs": [=0A    29,=0A    31,=0A    31,=0A    31,=0A    27=0A =
 ],=0A  "slabinfo.shmem_inode_cache.active_objs": [=0A    3839,=0A    3887,=
=0A    3599,=0A    3785,=0A    3503=0A  ],=0A  "slabinfo.shmem_inode_cache.=
num_objs": [=0A    3839,=0A    3887,=0A    3599,=0A    3785,=0A    3503=0A =
 ],=0A  "slabinfo.shmem_inode_cache.active_slabs": [=0A    79,=0A    80,=0A=
    74,=0A    78,=0A    72=0A  ],=0A  "slabinfo.shmem_inode_cache.num_slabs=
": [=0A    79,=0A    80,=0A    74,=0A    78,=0A    72=0A  ],=0A  "slabinfo.=
ftrace_event_file.active_objs": [=0A    1518,=0A    1518,=0A    1518,=0A   =
 1518,=0A    1518=0A  ],=0A  "slabinfo.ftrace_event_file.num_objs": [=0A   =
 1518,=0A    1518,=0A    1518,=0A    1518,=0A    1518=0A  ],=0A  "slabinfo.=
ftrace_event_file.active_slabs": [=0A    33,=0A    33,=0A    33,=0A    33,=
=0A    33=0A  ],=0A  "slabinfo.ftrace_event_file.num_slabs": [=0A    33,=0A=
    33,=0A    33,=0A    33,=0A    33=0A  ],=0A  "slabinfo.taskstats.active_=
objs": [=0A    98,=0A    98,=0A    49,=0A    98,=0A    98=0A  ],=0A  "slabi=
nfo.taskstats.num_objs": [=0A    98,=0A    98,=0A    49,=0A    98,=0A    98=
=0A  ],=0A  "slabinfo.taskstats.active_slabs": [=0A    2,=0A    2,=0A    1,=
=0A    2,=0A    2=0A  ],=0A  "slabinfo.taskstats.num_slabs": [=0A    2,=0A =
   2,=0A    1,=0A    2,=0A    2=0A  ],=0A  "slabinfo.proc_inode_cache.activ=
e_objs": [=0A    9345,=0A    9738,=0A    9602,=0A    10023,=0A    9898=0A  =
],=0A  "slabinfo.proc_inode_cache.num_objs": [=0A    9547,=0A    9889,=0A  =
  9602,=0A    10023,=0A    9913=0A  ],=0A  "slabinfo.proc_inode_cache.activ=
e_slabs": [=0A    190,=0A    197,=0A    192,=0A    200,=0A    198=0A  ],=0A=
  "slabinfo.proc_inode_cache.num_slabs": [=0A    190,=0A    197,=0A    192,=
=0A    200,=0A    198=0A  ],=0A  "slabinfo.sigqueue.active_objs": [=0A    2=
447,=0A    2447,=0A    2448,=0A    2448,=0A    2447=0A  ],=0A  "slabinfo.si=
gqueue.num_objs": [=0A    2447,=0A    2447,=0A    2448,=0A    2448,=0A    2=
447=0A  ],=0A  "slabinfo.sigqueue.active_slabs": [=0A    47,=0A    47,=0A  =
  48,=0A    48,=0A    47=0A  ],=0A  "slabinfo.sigqueue.num_slabs": [=0A    =
47,=0A    47,=0A    48,=0A    48,=0A    47=0A  ],=0A  "slabinfo.bdev_cache.=
active_objs": [=0A    39,=0A    39,=0A    39,=0A    39,=0A    39=0A  ],=0A =
 "slabinfo.bdev_cache.num_objs": [=0A    39,=0A    39,=0A    39,=0A    39,=
=0A    39=0A  ],=0A  "slabinfo.bdev_cache.active_slabs": [=0A    1,=0A    1=
,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.bdev_cache.num_slabs": [=
=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.kernfs_no=
de_cache.active_objs": [=0A    41752,=0A    41888,=0A    41820,=0A    41548=
,=0A    41616=0A  ],=0A  "slabinfo.kernfs_node_cache.num_objs": [=0A    417=
52,=0A    41888,=0A    41820,=0A    41548,=0A    41616=0A  ],=0A  "slabinfo=
=2Ekernfs_node_cache.active_slabs": [=0A    614,=0A    616,=0A    615,=0A  =
  611,=0A    612=0A  ],=0A  "slabinfo.kernfs_node_cache.num_slabs": [=0A   =
 614,=0A    616,=0A    615,=0A    611,=0A    612=0A  ],=0A  "slabinfo.mnt_c=
ache.active_objs": [=0A    357,=0A    408,=0A    255,=0A    408,=0A    306=
=0A  ],=0A  "slabinfo.mnt_cache.num_objs": [=0A    357,=0A    408,=0A    25=
5,=0A    408,=0A    306=0A  ],=0A  "slabinfo.mnt_cache.active_slabs": [=0A =
   7,=0A    8,=0A    5,=0A    8,=0A    6=0A  ],=0A  "slabinfo.mnt_cache.num=
_slabs": [=0A    7,=0A    8,=0A    5,=0A    8,=0A    6=0A  ],=0A  "slabinfo=
=2Einode_cache.active_objs": [=0A    51427,=0A    51376,=0A    51710,=0A   =
 51535,=0A    51512=0A  ],=0A  "slabinfo.inode_cache.num_objs": [=0A    519=
60,=0A    51866,=0A    52186,=0A    51992,=0A    51984=0A  ],=0A  "slabinfo=
=2Einode_cache.active_slabs": [=0A    927,=0A    926,=0A    931,=0A    928,=
=0A    928=0A  ],=0A  "slabinfo.inode_cache.num_slabs": [=0A    927,=0A    =
926,=0A    931,=0A    928,=0A    928=0A  ],=0A  "slabinfo.dentry.active_obj=
s": [=0A    108262,=0A    107976,=0A    109072,=0A    108296,=0A    108894=
=0A  ],=0A  "slabinfo.dentry.num_objs": [=0A    115462,=0A    115065,=0A   =
 116701,=0A    115439,=0A    116194=0A  ],=0A  "slabinfo.dentry.active_slab=
s": [=0A    2749,=0A    2739,=0A    2778,=0A    2748,=0A    2766=0A  ],=0A =
 "slabinfo.dentry.num_slabs": [=0A    2749,=0A    2739,=0A    2778,=0A    2=
748,=0A    2766=0A  ],=0A  "slabinfo.vm_area_struct.active_objs": [=0A    2=
3569,=0A    21236,=0A    23632,=0A    27246,=0A    26446=0A  ],=0A  "slabin=
fo.vm_area_struct.num_objs": [=0A    23569,=0A    21337,=0A    23632,=0A   =
 27318,=0A    26533=0A  ],=0A  "slabinfo.vm_area_struct.active_slabs": [=0A=
    535,=0A    484,=0A    537,=0A    620,=0A    603=0A  ],=0A  "slabinfo.vm=
_area_struct.num_slabs": [=0A    535,=0A    484,=0A    537,=0A    620,=0A  =
  603=0A  ],=0A  "slabinfo.mm_struct.active_objs": [=0A    1019,=0A    1036=
,=0A    984,=0A    1043,=0A    1070=0A  ],=0A  "slabinfo.mm_struct.num_objs=
": [=0A    1019,=0A    1036,=0A    984,=0A    1043,=0A    1070=0A  ],=0A  "=
slabinfo.mm_struct.active_slabs": [=0A    59,=0A    60,=0A    57,=0A    61,=
=0A    62=0A  ],=0A  "slabinfo.mm_struct.num_slabs": [=0A    59,=0A    60,=
=0A    57,=0A    61,=0A    62=0A  ],=0A  "slabinfo.files_cache.active_objs"=
: [=0A    2753,=0A    2753,=0A    2697,=0A    2754,=0A    2753=0A  ],=0A  "=
slabinfo.files_cache.num_objs": [=0A    2753,=0A    2753,=0A    2697,=0A   =
 2754,=0A    2753=0A  ],=0A  "slabinfo.files_cache.active_slabs": [=0A    5=
3,=0A    53,=0A    52,=0A    54,=0A    53=0A  ],=0A  "slabinfo.files_cache.=
num_slabs": [=0A    53,=0A    53,=0A    52,=0A    54,=0A    53=0A  ],=0A  "=
slabinfo.signal_cache.active_objs": [=0A    2867,=0A    2707,=0A    2757,=
=0A    2717,=0A    2895=0A  ],=0A  "slabinfo.signal_cache.num_objs": [=0A  =
  2995,=0A    2741,=0A    2799,=0A    2995,=0A    2963=0A  ],=0A  "slabinfo=
=2Esignal_cache.active_slabs": [=0A    106,=0A    97,=0A    99,=0A    106,=
=0A    105=0A  ],=0A  "slabinfo.signal_cache.num_slabs": [=0A    106,=0A   =
 97,=0A    99,=0A    106,=0A    105=0A  ],=0A  "slabinfo.sighand_cache.acti=
ve_objs": [=0A    1844,=0A    1859,=0A    1889,=0A    1885,=0A    1904=0A  =
],=0A  "slabinfo.sighand_cache.num_objs": [=0A    1874,=0A    1919,=0A    1=
889,=0A    1915,=0A    1904=0A  ],=0A  "slabinfo.sighand_cache.active_slabs=
": [=0A    124,=0A    127,=0A    125,=0A    127,=0A    126=0A  ],=0A  "slab=
info.sighand_cache.num_slabs": [=0A    124,=0A    127,=0A    125,=0A    127=
,=0A    126=0A  ],=0A  "slabinfo.task_xstate.active_objs": [=0A    3626,=0A=
    3237,=0A    3349,=0A    3353,=0A    3236=0A  ],=0A  "slabinfo.task_xsta=
te.num_objs": [=0A    3626,=0A    3237,=0A    3349,=0A    3353,=0A    3236=
=0A  ],=0A  "slabinfo.task_xstate.active_slabs": [=0A    92,=0A    83,=0A  =
  85,=0A    85,=0A    82=0A  ],=0A  "slabinfo.task_xstate.num_slabs": [=0A =
   92,=0A    83,=0A    85,=0A    85,=0A    82=0A  ],=0A  "slabinfo.task_str=
uct.active_objs": [=0A    1412,=0A    1449,=0A    1454,=0A    1450,=0A    1=
403=0A  ],=0A  "slabinfo.task_struct.num_objs": [=0A    1433,=0A    1465,=
=0A    1469,=0A    1472,=0A    1418=0A  ],=0A  "slabinfo.task_struct.active=
_slabs": [=0A    358,=0A    366,=0A    367,=0A    368,=0A    354=0A  ],=0A =
 "slabinfo.task_struct.num_slabs": [=0A    358,=0A    366,=0A    367,=0A   =
 368,=0A    354=0A  ],=0A  "slabinfo.Acpi-ParseExt.active_objs": [=0A    14=
0952,=0A    141008,=0A    141008,=0A    141008,=0A    141008=0A  ],=0A  "sl=
abinfo.Acpi-ParseExt.num_objs": [=0A    140952,=0A    141008,=0A    141008,=
=0A    141008,=0A    141008=0A  ],=0A  "slabinfo.Acpi-ParseExt.active_slabs=
": [=0A    2517,=0A    2518,=0A    2518,=0A    2518,=0A    2518=0A  ],=0A  =
"slabinfo.Acpi-ParseExt.num_slabs": [=0A    2517,=0A    2518,=0A    2518,=
=0A    2518,=0A    2518=0A  ],=0A  "slabinfo.Acpi-State.active_objs": [=0A =
   67639,=0A    67163,=0A    68071,=0A    67473,=0A    67701=0A  ],=0A  "sl=
abinfo.Acpi-State.num_objs": [=0A    67922,=0A    67450,=0A    68336,=0A   =
 67748,=0A    67999=0A  ],=0A  "slabinfo.Acpi-State.active_slabs": [=0A    =
1331,=0A    1322,=0A    1339,=0A    1328,=0A    1333=0A  ],=0A  "slabinfo.A=
cpi-State.num_slabs": [=0A    1331,=0A    1322,=0A    1339,=0A    1328,=0A =
   1333=0A  ],=0A  "slabinfo.Acpi-Namespace.active_objs": [=0A    14979,=0A=
    14264,=0A    14483,=0A    14264,=0A    14469=0A  ],=0A  "slabinfo.Acpi-=
Namespace.num_objs": [=0A    14979,=0A    14264,=0A    14483,=0A    14264,=
=0A    14469=0A  ],=0A  "slabinfo.Acpi-Namespace.active_slabs": [=0A    146=
,=0A    139,=0A    141,=0A    139,=0A    141=0A  ],=0A  "slabinfo.Acpi-Name=
space.num_slabs": [=0A    146,=0A    139,=0A    141,=0A    139,=0A    141=
=0A  ],=0A  "slabinfo.anon_vma.active_objs": [=0A    10169,=0A    10514,=0A=
    9454,=0A    11136,=0A    11340=0A  ],=0A  "slabinfo.anon_vma.num_objs":=
 [=0A    10169,=0A    10514,=0A    9454,=0A    11136,=0A    11340=0A  ],=0A=
  "slabinfo.anon_vma.active_slabs": [=0A    181,=0A    187,=0A    168,=0A  =
  198,=0A    202=0A  ],=0A  "slabinfo.anon_vma.num_slabs": [=0A    181,=0A =
   187,=0A    168,=0A    198,=0A    202=0A  ],=0A  "slabinfo.shared_policy_=
node.active_objs": [=0A    6885,=0A    6885,=0A    6885,=0A    6885,=0A    =
6885=0A  ],=0A  "slabinfo.shared_policy_node.num_objs": [=0A    6885,=0A   =
 6885,=0A    6885,=0A    6885,=0A    6885=0A  ],=0A  "slabinfo.shared_polic=
y_node.active_slabs": [=0A    81,=0A    81,=0A    81,=0A    81,=0A    81=0A=
  ],=0A  "slabinfo.shared_policy_node.num_slabs": [=0A    81,=0A    81,=0A =
   81,=0A    81,=0A    81=0A  ],=0A  "slabinfo.numa_policy.active_objs": [=
=0A    248,=0A    248,=0A    248,=0A    248,=0A    248=0A  ],=0A  "slabinfo=
=2Enuma_policy.num_objs": [=0A    248,=0A    248,=0A    248,=0A    248,=0A =
   248=0A  ],=0A  "slabinfo.numa_policy.active_slabs": [=0A    4,=0A    4,=
=0A    4,=0A    4,=0A    4=0A  ],=0A  "slabinfo.numa_policy.num_slabs": [=
=0A    4,=0A    4,=0A    4,=0A    4,=0A    4=0A  ],=0A  "slabinfo.radix_tre=
e_node.active_objs": [=0A    24241,=0A    24334,=0A    24585,=0A    24471,=
=0A    24491=0A  ],=0A  "slabinfo.radix_tree_node.num_objs": [=0A    24661,=
=0A    24790,=0A    24959,=0A    24880,=0A    24924=0A  ],=0A  "slabinfo.ra=
dix_tree_node.active_slabs": [=0A    440,=0A    442,=0A    445,=0A    444,=
=0A    445=0A  ],=0A  "slabinfo.radix_tree_node.num_slabs": [=0A    440,=0A=
    442,=0A    445,=0A    444,=0A    445=0A  ],=0A  "slabinfo.idr_layer_cac=
he.active_objs": [=0A    1515,=0A    1515,=0A    1500,=0A    1515,=0A    15=
15=0A  ],=0A  "slabinfo.idr_layer_cache.num_objs": [=0A    1515,=0A    1515=
,=0A    1500,=0A    1515,=0A    1515=0A  ],=0A  "slabinfo.idr_layer_cache.a=
ctive_slabs": [=0A    101,=0A    101,=0A    100,=0A    101,=0A    101=0A  ]=
,=0A  "slabinfo.idr_layer_cache.num_slabs": [=0A    101,=0A    101,=0A    1=
00,=0A    101,=0A    101=0A  ],=0A  "slabinfo.kmalloc-8192.active_objs": [=
=0A    148,=0A    152,=0A    148,=0A    148,=0A    152=0A  ],=0A  "slabinfo=
=2Ekmalloc-8192.num_objs": [=0A    148,=0A    152,=0A    148,=0A    148,=0A=
    152=0A  ],=0A  "slabinfo.kmalloc-8192.active_slabs": [=0A    37,=0A    =
38,=0A    37,=0A    37,=0A    38=0A  ],=0A  "slabinfo.kmalloc-8192.num_slab=
s": [=0A    37,=0A    38,=0A    37,=0A    37,=0A    38=0A  ],=0A  "slabinfo=
=2Ekmalloc-4096.active_objs": [=0A    659,=0A    667,=0A    661,=0A    660,=
=0A    657=0A  ],=0A  "slabinfo.kmalloc-4096.num_objs": [=0A    745,=0A    =
759,=0A    755,=0A    752,=0A    743=0A  ],=0A  "slabinfo.kmalloc-4096.acti=
ve_slabs": [=0A    93,=0A    94,=0A    94,=0A    94,=0A    92=0A  ],=0A  "s=
labinfo.kmalloc-4096.num_slabs": [=0A    93,=0A    94,=0A    94,=0A    94,=
=0A    92=0A  ],=0A  "slabinfo.kmalloc-2048.active_objs": [=0A    2137,=0A =
   2299,=0A    2188,=0A    2169,=0A    2236=0A  ],=0A  "slabinfo.kmalloc-20=
48.num_objs": [=0A    2272,=0A    2448,=0A    2320,=0A    2304,=0A    2352=
=0A  ],=0A  "slabinfo.kmalloc-2048.active_slabs": [=0A    142,=0A    153,=
=0A    145,=0A    144,=0A    147=0A  ],=0A  "slabinfo.kmalloc-2048.num_slab=
s": [=0A    142,=0A    153,=0A    145,=0A    144,=0A    147=0A  ],=0A  "sla=
binfo.kmalloc-1024.active_objs": [=0A    4891,=0A    4916,=0A    4955,=0A  =
  4672,=0A    4891=0A  ],=0A  "slabinfo.kmalloc-1024.num_objs": [=0A    489=
1,=0A    4916,=0A    4955,=0A    4832,=0A    4891=0A  ],=0A  "slabinfo.kmal=
loc-1024.active_slabs": [=0A    152,=0A    153,=0A    154,=0A    151,=0A   =
 152=0A  ],=0A  "slabinfo.kmalloc-1024.num_slabs": [=0A    152,=0A    153,=
=0A    154,=0A    151,=0A    152=0A  ],=0A  "slabinfo.kmalloc-512.active_ob=
js": [=0A    9169,=0A    9104,=0A    9040,=0A    8484,=0A    9104=0A  ],=0A=
  "slabinfo.kmalloc-512.num_objs": [=0A    9216,=0A    9152,=0A    9088,=0A=
    8512,=0A    9152=0A  ],=0A  "slabinfo.kmalloc-512.active_slabs": [=0A  =
  144,=0A    143,=0A    142,=0A    133,=0A    143=0A  ],=0A  "slabinfo.kmal=
loc-512.num_slabs": [=0A    144,=0A    143,=0A    142,=0A    133,=0A    143=
=0A  ],=0A  "slabinfo.kmalloc-256.active_objs": [=0A    92186,=0A    91724,=
=0A    93656,=0A    92175,=0A    92881=0A  ],=0A  "slabinfo.kmalloc-256.num=
_objs": [=0A    94840,=0A    94224,=0A    96704,=0A    94892,=0A    95983=
=0A  ],=0A  "slabinfo.kmalloc-256.active_slabs": [=0A    1481,=0A    1472,=
=0A    1511,=0A    1482,=0A    1499=0A  ],=0A  "slabinfo.kmalloc-256.num_sl=
abs": [=0A    1481,=0A    1472,=0A    1511,=0A    1482,=0A    1499=0A  ],=
=0A  "slabinfo.kmalloc-192.active_objs": [=0A    11747,=0A    12669,=0A    =
13418,=0A    12222,=0A    13647=0A  ],=0A  "slabinfo.kmalloc-192.num_objs":=
 [=0A    11747,=0A    12669,=0A    13418,=0A    12222,=0A    13647=0A  ],=
=0A  "slabinfo.kmalloc-192.active_slabs": [=0A    279,=0A    301,=0A    319=
,=0A    291,=0A    324=0A  ],=0A  "slabinfo.kmalloc-192.num_slabs": [=0A   =
 279,=0A    301,=0A    319,=0A    291,=0A    324=0A  ],=0A  "slabinfo.kmall=
oc-128.active_objs": [=0A    5861,=0A    5733,=0A    5861,=0A    5998,=0A  =
  5742=0A  ],=0A  "slabinfo.kmalloc-128.num_objs": [=0A    5916,=0A    5787=
,=0A    5916,=0A    6053,=0A    5797=0A  ],=0A  "slabinfo.kmalloc-128.activ=
e_slabs": [=0A    92,=0A    90,=0A    92,=0A    94,=0A    90=0A  ],=0A  "sl=
abinfo.kmalloc-128.num_slabs": [=0A    92,=0A    90,=0A    92,=0A    94,=0A=
    90=0A  ],=0A  "slabinfo.kmalloc-96.active_objs": [=0A    3831,=0A    37=
38,=0A    3906,=0A    3738,=0A    3948=0A  ],=0A  "slabinfo.kmalloc-96.num_=
objs": [=0A    3906,=0A    3780,=0A    3948,=0A    3780,=0A    3990=0A  ],=
=0A  "slabinfo.kmalloc-96.active_slabs": [=0A    93,=0A    90,=0A    94,=0A=
    90,=0A    95=0A  ],=0A  "slabinfo.kmalloc-96.num_slabs": [=0A    93,=0A=
    90,=0A    94,=0A    90,=0A    95=0A  ],=0A  "slabinfo.kmalloc-64.active=
_objs": [=0A    65373,=0A    63193,=0A    63555,=0A    64753,=0A    66702=
=0A  ],=0A  "slabinfo.kmalloc-64.num_objs": [=0A    65374,=0A    63584,=0A =
   63556,=0A    65189,=0A    66819=0A  ],=0A  "slabinfo.kmalloc-64.active_s=
labs": [=0A    1021,=0A    993,=0A    993,=0A    1018,=0A    1044=0A  ],=0A=
  "slabinfo.kmalloc-64.num_slabs": [=0A    1021,=0A    993,=0A    993,=0A  =
  1018,=0A    1044=0A  ],=0A  "slabinfo.kmalloc-32.active_objs": [=0A    31=
103,=0A    31074,=0A    30714,=0A    30975,=0A    31231=0A  ],=0A  "slabinf=
o.kmalloc-32.num_objs": [=0A    31103,=0A    31074,=0A    30714,=0A    3097=
5,=0A    31231=0A  ],=0A  "slabinfo.kmalloc-32.active_slabs": [=0A    242,=
=0A    242,=0A    239,=0A    241,=0A    243=0A  ],=0A  "slabinfo.kmalloc-32=
=2Enum_slabs": [=0A    242,=0A    242,=0A    239,=0A    241,=0A    243=0A  =
],=0A  "slabinfo.kmalloc-16.active_objs": [=0A    19182,=0A    19181,=0A   =
 19341,=0A    19199,=0A    18943=0A  ],=0A  "slabinfo.kmalloc-16.num_objs":=
 [=0A    19182,=0A    19181,=0A    19341,=0A    19199,=0A    18943=0A  ],=
=0A  "slabinfo.kmalloc-16.active_slabs": [=0A    74,=0A    74,=0A    75,=0A=
    74,=0A    73=0A  ],=0A  "slabinfo.kmalloc-16.num_slabs": [=0A    74,=0A=
    74,=0A    75,=0A    74,=0A    73=0A  ],=0A  "slabinfo.kmalloc-8.active_=
objs": [=0A    29696,=0A    30208,=0A    30208,=0A    30208,=0A    30208=0A=
  ],=0A  "slabinfo.kmalloc-8.num_objs": [=0A    29696,=0A    30208,=0A    3=
0208,=0A    30208,=0A    30208=0A  ],=0A  "slabinfo.kmalloc-8.active_slabs"=
: [=0A    58,=0A    59,=0A    59,=0A    59,=0A    59=0A  ],=0A  "slabinfo.k=
malloc-8.num_slabs": [=0A    58,=0A    59,=0A    59,=0A    59,=0A    59=0A =
 ],=0A  "slabinfo.kmem_cache_node.active_objs": [=0A    623,=0A    431,=0A =
   431,=0A    559,=0A    495=0A  ],=0A  "slabinfo.kmem_cache_node.num_objs"=
: [=0A    640,=0A    448,=0A    448,=0A    576,=0A    512=0A  ],=0A  "slabi=
nfo.kmem_cache_node.active_slabs": [=0A    10,=0A    7,=0A    7,=0A    9,=
=0A    8=0A  ],=0A  "slabinfo.kmem_cache_node.num_slabs": [=0A    10,=0A   =
 7,=0A    7,=0A    9,=0A    8=0A  ],=0A  "slabinfo.kmem_cache.active_objs":=
 [=0A    512,=0A    320,=0A    320,=0A    448,=0A    384=0A  ],=0A  "slabin=
fo.kmem_cache.num_objs": [=0A    512,=0A    320,=0A    320,=0A    448,=0A  =
  384=0A  ],=0A  "slabinfo.kmem_cache.active_slabs": [=0A    8,=0A    5,=0A=
    5,=0A    7,=0A    6=0A  ],=0A  "slabinfo.kmem_cache.num_slabs": [=0A   =
 8,=0A    5,=0A    5,=0A    7,=0A    6=0A  ],=0A  "numa-meminfo.node0.MemTo=
tal": [=0A    32853760,=0A    32853760,=0A    32853760,=0A    32853760,=0A =
   32853760=0A  ],=0A  "numa-meminfo.node0.MemFree": [=0A    31550481,=0A  =
  31726284,=0A    31550465,=0A    31573138,=0A    31749014=0A  ],=0A  "numa=
-meminfo.node0.MemUsed": [=0A    1303278,=0A    1127475,=0A    1303294,=0A =
   1280621,=0A    1104745=0A  ],=0A  "numa-meminfo.node0.Active": [=0A    3=
51801,=0A    176190,=0A    371088,=0A    329222,=0A    168642=0A  ],=0A  "n=
uma-meminfo.node0.Inactive": [=0A    606228,=0A    609601,=0A    594515,=0A=
    609678,=0A    595654=0A  ],=0A  "numa-meminfo.node0.Active(anon)": [=0A=
    195096,=0A    20431,=0A    220046,=0A    171555,=0A    18537=0A  ],=0A =
 "numa-meminfo.node0.Inactive(anon)": [=0A    1714,=0A    222,=0A    1663,=
=0A    1421,=0A    141=0A  ],=0A  "numa-meminfo.node0.Active(file)": [=0A  =
  156705,=0A    155759,=0A    151042,=0A    157667,=0A    150104=0A  ],=0A =
 "numa-meminfo.node0.Inactive(file)": [=0A    604513,=0A    609381,=0A    5=
92852,=0A    608256,=0A    595512=0A  ],=0A  "numa-meminfo.node0.Dirty": [=
=0A    6,=0A    7,=0A    1,=0A    1,=0A    11=0A  ],=0A  "numa-meminfo.node=
0.FilePages": [=0A    940400,=0A    765617,=0A    947730,=0A    915765,=0A =
   746169=0A  ],=0A  "numa-meminfo.node0.Mapped": [=0A    6017,=0A    5623,=
=0A    5858,=0A    5622,=0A    5652=0A  ],=0A  "numa-meminfo.node0.AnonPage=
s": [=0A    17827,=0A    20174,=0A    17932,=0A    23101,=0A    18281=0A  ]=
,=0A  "numa-meminfo.node0.Shmem": [=0A    178988,=0A    478,=0A    203784,=
=0A    149875,=0A    397=0A  ],=0A  "numa-meminfo.node0.KernelStack": [=0A =
   14650,=0A    14982,=0A    14693,=0A    14646,=0A    14757=0A  ],=0A  "nu=
ma-meminfo.node0.PageTables": [=0A    1638,=0A    1859,=0A    1513,=0A    1=
869,=0A    1615=0A  ],=0A  "numa-meminfo.node0.Slab": [=0A    100709,=0A   =
 98461,=0A    93777,=0A    99016,=0A    95347=0A  ],=0A  "numa-meminfo.node=
0.SReclaimable": [=0A    40356,=0A    35342,=0A    37802,=0A    36821,=0A  =
  37246=0A  ],=0A  "numa-meminfo.node0.SUnreclaim": [=0A    60352,=0A    63=
118,=0A    55975,=0A    62194,=0A    58101=0A  ],=0A  "numa-meminfo.node0.A=
nonHugePages": [=0A    32,=0A    0,=0A    0,=0A    4037=0A  ],=0A  "numa-me=
minfo.node1.MemTotal": [=0A    33015508,=0A    33015508,=0A    33015508,=0A=
    33015508,=0A    33015508=0A  ],=0A  "numa-meminfo.node1.MemFree": [=0A =
   31937062,=0A    31759621,=0A    31933288,=0A    31910025,=0A    31735181=
=0A  ],=0A  "numa-meminfo.node1.MemUsed": [=0A    1078445,=0A    1255886,=
=0A    1082219,=0A    1105482,=0A    1280326=0A  ],=0A  "numa-meminfo.node1=
=2EActive": [=0A    184464,=0A    359472,=0A    166767,=0A    209190,=0A   =
 367968=0A  ],=0A  "numa-meminfo.node1.Inactive": [=0A    576189,=0A    574=
447,=0A    589093,=0A    573456,=0A    588844=0A  ],=0A  "numa-meminfo.node=
1.Active(anon)": [=0A    38248,=0A    213588,=0A    16282,=0A    63743,=0A =
   216241=0A  ],=0A  "numa-meminfo.node1.Inactive(anon)": [=0A    2989,=0A =
   4475,=0A    3020,=0A    3074,=0A    4580=0A  ],=0A  "numa-meminfo.node1.=
Active(file)": [=0A    146215,=0A    145883,=0A    150485,=0A    145446,=0A=
    151726=0A  ],=0A  "numa-meminfo.node1.Inactive(file)": [=0A    573199,=
=0A    569972,=0A    586072,=0A    570381,=0A    584263=0A  ],=0A  "numa-me=
minfo.node1.Dirty": [=0A    7,=0A    7,=0A    13,=0A    13,=0A    3=0A  ],=
=0A  "numa-meminfo.node1.FilePages": [=0A    744462,=0A    919826,=0A    74=
0110,=0A    771565,=0A    941039=0A  ],=0A  "numa-meminfo.node1.Mapped": [=
=0A    5778,=0A    5920,=0A    5665,=0A    5617,=0A    5982=0A  ],=0A  "num=
a-meminfo.node1.AnonPages": [=0A    16272,=0A    14045,=0A    15914,=0A    =
11103,=0A    15945=0A  ],=0A  "numa-meminfo.node1.Shmem": [=0A    24968,=0A=
    204026,=0A    3391,=0A    55716,=0A    204887=0A  ],=0A  "numa-meminfo.=
node1.KernelStack": [=0A    3371,=0A    3042,=0A    3323,=0A    3374,=0A   =
 3264=0A  ],=0A  "numa-meminfo.node1.PageTables": [=0A    2752,=0A    2532,=
=0A    2876,=0A    2553,=0A    2580=0A  ],=0A  "numa-meminfo.node1.Slab": [=
=0A    86169,=0A    89181,=0A    94107,=0A    88546,=0A    92154=0A  ],=0A =
 "numa-meminfo.node1.SReclaimable": [=0A    33712,=0A    39262,=0A    36877=
,=0A    37599,=0A    36935=0A  ],=0A  "numa-meminfo.node1.SUnreclaim": [=0A=
    52457,=0A    49918,=0A    57230,=0A    50947,=0A    55219=0A  ],=0A  "n=
uma-meminfo.node1.AnonHugePages": [=0A    3667,=0A    2018,=0A    4037,=0A =
   0,=0A    2050=0A  ],=0A  "numa-vmstat.node0.nr_free_pages": [=0A    7887=
658,=0A    7931496,=0A    7887611,=0A    7893240,=0A    7937318=0A  ],=0A  =
"numa-vmstat.node0.nr_alloc_batch": [=0A    1751,=0A    1764,=0A    1689,=
=0A    1785,=0A    1718=0A  ],=0A  "numa-vmstat.node0.nr_inactive_anon": [=
=0A    430,=0A    55,=0A    408,=0A    355,=0A    35=0A  ],=0A  "numa-vmsta=
t.node0.nr_active_anon": [=0A    48775,=0A    5107,=0A    55008,=0A    4288=
8,=0A    4634=0A  ],=0A  "numa-vmstat.node0.nr_inactive_file": [=0A    1511=
61,=0A    152454,=0A    148252,=0A    152152,=0A    148834=0A  ],=0A  "numa=
-vmstat.node0.nr_active_file": [=0A    39210,=0A    38948,=0A    37789,=0A =
   39422,=0A    37516=0A  ],=0A  "numa-vmstat.node0.nr_anon_pages": [=0A   =
 4456,=0A    5043,=0A    4483,=0A    5775,=0A    4570=0A  ],=0A  "numa-vmst=
at.node0.nr_mapped": [=0A    1504,=0A    1405,=0A    1442,=0A    1405,=0A  =
  1413=0A  ],=0A  "numa-vmstat.node0.nr_file_pages": [=0A    235157,=0A    =
191515,=0A    237001,=0A    229024,=0A    186473=0A  ],=0A  "numa-vmstat.no=
de0.nr_dirty": [=0A    1,=0A    1,=0A    0,=0A    0,=0A    2=0A  ],=0A  "nu=
ma-vmstat.node0.nr_slab_reclaimable": [=0A    10070,=0A    8835,=0A    9467=
,=0A    9207,=0A    9309=0A  ],=0A  "numa-vmstat.node0.nr_slab_unreclaimabl=
e": [=0A    15039,=0A    15767,=0A    13978,=0A    15544,=0A    14520=0A  ]=
,=0A  "numa-vmstat.node0.nr_page_table_pages": [=0A    410,=0A    464,=0A  =
  378,=0A    467,=0A    403=0A  ],=0A  "numa-vmstat.node0.nr_kernel_stack":=
 [=0A    915,=0A    936,=0A    918,=0A    915,=0A    922=0A  ],=0A  "numa-v=
mstat.node0.nr_isolated_anon": [=0A    0=0A  ],=0A  "numa-vmstat.node0.nr_s=
hmem": [=0A    44750,=0A    119,=0A    50934,=0A    37468,=0A    99=0A  ],=
=0A  "numa-vmstat.node0.nr_dirtied": [=0A    83,=0A    84,=0A    55,=0A    =
51,=0A    105=0A  ],=0A  "numa-vmstat.node0.nr_written": [=0A    82,=0A    =
82,=0A    55,=0A    50,=0A    102=0A  ],=0A  "numa-vmstat.node0.numa_hit": =
[=0A    223723909,=0A    222779136,=0A    229671004,=0A    222123698,=0A   =
 226801754=0A  ],=0A  "numa-vmstat.node0.numa_interleave": [=0A    75966,=
=0A    76076,=0A    75744,=0A    76328,=0A    76026=0A  ],=0A  "numa-vmstat=
=2Enode0.numa_local": [=0A    223720940,=0A    222711306,=0A    229608996,=
=0A    222061040,=0A    226734006=0A  ],=0A  "numa-vmstat.node0.numa_other"=
: [=0A    2968,=0A    67830,=0A    62007,=0A    62658,=0A    67748=0A  ],=
=0A  "numa-vmstat.node0.nr_anon_transparent_hugepages": [=0A    0,=0A    0,=
=0A    0,=0A    1=0A  ],=0A  "numa-vmstat.node1.nr_free_pages": [=0A    798=
4446,=0A    7939789,=0A    7983375,=0A    7977596,=0A    7933835=0A  ],=0A =
 "numa-vmstat.node1.nr_alloc_batch": [=0A    1612,=0A    1633,=0A    1671,=
=0A    1715,=0A    1756=0A  ],=0A  "numa-vmstat.node1.nr_inactive_anon": [=
=0A    747,=0A    1117,=0A    755,=0A    768,=0A    1144=0A  ],=0A  "numa-v=
mstat.node1.nr_active_anon": [=0A    9563,=0A    53396,=0A    4070,=0A    1=
5936,=0A    54060=0A  ],=0A  "numa-vmstat.node1.nr_inactive_file": [=0A    =
143219,=0A    142618,=0A    146532,=0A    142548,=0A    146061=0A  ],=0A  "=
numa-vmstat.node1.nr_active_file": [=0A    36540,=0A    36483,=0A    37595,=
=0A    36350,=0A    37930=0A  ],=0A  "numa-vmstat.node1.nr_anon_pages": [=
=0A    4068,=0A    3511,=0A    3978,=0A    2776,=0A    3986=0A  ],=0A  "num=
a-vmstat.node1.nr_mapped": [=0A    1442,=0A    1479,=0A    1412,=0A    1404=
,=0A    1498=0A  ],=0A  "numa-vmstat.node1.nr_file_pages": [=0A    186015,=
=0A    230102,=0A    185043,=0A    192827,=0A    235255=0A  ],=0A  "numa-vm=
stat.node1.nr_dirty": [=0A    1,=0A    1,=0A    3,=0A    3,=0A    0=0A  ],=
=0A  "numa-vmstat.node1.nr_slab_reclaimable": [=0A    8401,=0A    9805,=0A =
   9216,=0A    9388,=0A    9233=0A  ],=0A  "numa-vmstat.node1.nr_slab_unrec=
laimable": [=0A    13086,=0A    12447,=0A    14293,=0A    12745,=0A    1380=
3=0A  ],=0A  "numa-vmstat.node1.nr_page_table_pages": [=0A    688,=0A    63=
2,=0A    718,=0A    638,=0A    644=0A  ],=0A  "numa-vmstat.node1.nr_kernel_=
stack": [=0A    211,=0A    190,=0A    207,=0A    210,=0A    203=0A  ],=0A  =
"numa-vmstat.node1.nr_isolated_anon": [=0A    0,=0A    0,=0A    0,=0A    0,=
=0A    0=0A  ],=0A  "numa-vmstat.node1.nr_shmem": [=0A    6242,=0A    51005=
,=0A    847,=0A    13928,=0A    51220=0A  ],=0A  "numa-vmstat.node1.nr_dirt=
ied": [=0A    57,=0A    58,=0A    86,=0A    90,=0A    37=0A  ],=0A  "numa-v=
mstat.node1.nr_written": [=0A    56,=0A    56,=0A    83,=0A    87,=0A    36=
=0A  ],=0A  "numa-vmstat.node1.numa_hit": [=0A    224996153,=0A    22613670=
3,=0A    223930339,=0A    224531613,=0A    221580945=0A  ],=0A  "numa-vmsta=
t.node1.numa_interleave": [=0A    76094,=0A    75961,=0A    76278,=0A    75=
710,=0A    76014=0A  ],=0A  "numa-vmstat.node1.numa_local": [=0A    2249159=
69,=0A    226121280,=0A    223909222,=0A    224510932,=0A    221565505=0A  =
],=0A  "numa-vmstat.node1.numa_other": [=0A    80184,=0A    15423,=0A    21=
117,=0A    20681,=0A    15440=0A  ],=0A  "numa-vmstat.node1.nr_anon_transpa=
rent_hugepages": [=0A    1,=0A    0,=0A    1,=0A    0,=0A    1=0A  ],=0A  "=
stats_source": [=0A    "/result/ivb44/dbench/100%/x86_64-rhel/f7b5d647946aa=
e1647bf5cd26c16b3a793c1ac49/0/stats.json",=0A    "/result/ivb44/dbench/100%=
/x86_64-rhel/f7b5d647946aae1647bf5cd26c16b3a793c1ac49/1/stats.json",=0A    =
"/result/ivb44/dbench/100%/x86_64-rhel/f7b5d647946aae1647bf5cd26c16b3a793c1=
ac49/2/stats.json",=0A    "/result/ivb44/dbench/100%/x86_64-rhel/f7b5d64794=
6aae1647bf5cd26c16b3a793c1ac49/3/stats.json",=0A    "/result/ivb44/dbench/1=
00%/x86_64-rhel/f7b5d647946aae1647bf5cd26c16b3a793c1ac49/4/stats.json"=0A  =
],=0A  "softirqs.CPU20.NET_TX": [=0A    0,=0A    1=0A  ],=0A  "softirqs.CPU=
1.TASKLET": [=0A    0,=0A    1,=0A    1=0A  ],=0A  "softirqs.CPU2.TASKLET":=
 [=0A    0,=0A    1,=0A    1=0A  ],=0A  "softirqs.CPU3.TASKLET": [=0A    0,=
=0A    1,=0A    2=0A  ],=0A  "softirqs.CPU19.TASKLET": [=0A    0,=0A    1,=
=0A    0,=0A    2,=0A    1=0A  ],=0A  "perf-profile.cpu-cycles.generic_exec=
_single.smp_call_function_single.smp_call_function_many.native_flush_tlb_ot=
hers.flush_tlb_page": [=0A    0,=0A    0.02,=0A    0,=0A    0.02=0A  ],=0A =
 "perf-profile.cpu-cycles.native_iret.close": [=0A    0,=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__call_rcu=
=2E__fput.____fput.task_work_run.do_notify_resume": [=0A    0,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.sec=
urity_inode_permission.inode_permission.may_open.do_last.path_openat": [=0A=
    0,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.vfs_read.system_call_=
fastpath.pread64": [=0A    0,=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles.__fsnotify_parent.____fput.task_work_=
run.do_notify_resume.int_signal": [=0A    0,=0A    0.01=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.path_get.do_dentry_open.finish_open.do_last.path_openat": =
[=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__radix_tree_prel=
oad.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.gra=
b_cache_page_write_begin": [=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A=
  ],=0A  "perf-profile.cpu-cycles.ima_match_policy.process_measurement.ima_=
file_check.do_last.path_openat": [=0A    0,=0A    0.01,=0A    0,=0A    0,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.final_putname.putname.user_=
path_at_empty.user_path_at.vfs_fstatat": [=0A    0,=0A    0.01,=0A    0,=0A=
    0.01=0A  ],=0A  "perf-profile.cpu-cycles.final_putname.putname.do_sys_o=
pen.sys_openat.system_call_fastpath": [=0A    0,=0A    0.01,=0A    0.02,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.cmpxchg_double_sla=
b.isra.51.__slab_free.kmem_cache_free.inode_free_rcu.rcu_nocb_kthread": [=
=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__mod_zone_page_st=
ate.__pagevec_lru_add_fn.pagevec_lru_move_fn.__lru_cache_add.lru_cache_add"=
: [=0A    0,=0A    0.01,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.wait_for_stable_page.simple_write_begin.generic_perform_writ=
e.__generic_file_write_iter.generic_file_write_iter": [=0A    0,=0A    0.01=
,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.final=
_putname.user_path_at_empty.user_path_at.vfs_fstatat.SYSC_newstat": [=0A   =
 0,=0A    0.01,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.simple_lookup.do_last.path_openat.do_filp_open.do_sys_open": [=0A =
   0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.grab_cache_page_write_=
begin.generic_perform_write.__generic_file_write_iter.generic_file_write_it=
er.new_sync_write": [=0A    0,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles.current_fs_time.iterate_dir.sys_getd=
ents.system_call_fastpath": [=0A    0,=0A    0.01,=0A    0.01,=0A    0.02,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.lookup_dcache.lookup_slow.p=
ath_lookupat.filename_lookup.user_path_at_empty": [=0A    0,=0A    0.01=0A =
 ],=0A  "perf-profile.cpu-cycles.__mark_inode_dirty.update_time.file_update=
_time.__generic_file_write_iter.generic_file_write_iter": [=0A    0,=0A    =
0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycle=
s.get_pfnblock_flags_mask.free_hot_cold_page_list.release_pages.__pagevec_r=
elease.truncate_inode_pages_range": [=0A    0,=0A    0.01,=0A    0.01,=0A  =
  0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.update_curr.task_tic=
k_fair.scheduler_tick.update_process_times.tick_sched_handle": [=0A    0,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.add_to_page_cache_lru.grab_=
cache_page_write_begin.simple_write_begin.generic_perform_write.__generic_f=
ile_write_iter": [=0A    0,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.avc_policy_seqno.security_file_permiss=
ion.rw_verify_area.vfs_read.sys_pread64": [=0A    0,=0A    0.01=0A  ],=0A  =
"perf-profile.cpu-cycles.__dentry_kill.terminate_walk.path_lookupat.filenam=
e_lookup.user_path_at_empty": [=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  =
"perf-profile.cpu-cycles.selinux_inode_getattr.security_inode_getattr.vfs_g=
etattr.vfs_fstat.SYSC_newfstat": [=0A    0,=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.security_compute_sid.=
may_create.selinux_inode_create.security_inode_create.vfs_create": [=0A    =
0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.make=
_kgid.alloc_inode.new_inode_pseudo.new_inode.ramfs_get_inode": [=0A    0,=
=0A    0.01,=0A    0.01=0A  ],=0A  "turbostat.%pc2": [=0A    0,=0A    0.04,=
=0A    0,=0A    0.02,=0A    0.03=0A  ],=0A  "numa-meminfo.node1.Writeback":=
 [=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "numa-vmstat.node1.nr_writ=
eback": [=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "softirqs.CPU15.NET=
_TX": [=0A    0,=0A    0,=0A    1=0A  ],=0A  "softirqs.CPU4.TASKLET": [=0A =
   0,=0A    0,=0A    2=0A  ],=0A  "softirqs.CPU5.TASKLET": [=0A    0,=0A   =
 0,=0A    2=0A  ],=0A  "softirqs.CPU6.TASKLET": [=0A    0,=0A    0,=0A    2=
=0A  ],=0A  "softirqs.CPU8.TASKLET": [=0A    0,=0A    0,=0A    3=0A  ],=0A =
 "softirqs.CPU9.TASKLET": [=0A    0,=0A    0,=0A    1=0A  ],=0A  "softirqs.=
CPU10.TASKLET": [=0A    0,=0A    0,=0A    1=0A  ],=0A  "softirqs.CPU11.TASK=
LET": [=0A    0,=0A    0,=0A    1=0A  ],=0A  "perf-profile.cpu-cycles.fsnot=
ify.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=0A    0,=
=0A    0,=0A    0.04,=0A    0,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycl=
es.do_last.do_filp_open.do_sys_open.sys_openat.system_call_fastpath": [=0A =
   0,=0A    0,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__dec_zone_pa=
ge_state.__delete_from_page_cache.delete_from_page_cache.truncate_inode_pag=
e.truncate_inode_pages_range": [=0A    0,=0A    0,=0A    0.01,=0A    0,=0A =
   0.01=0A  ],=0A  "perf-profile.cpu-cycles.file_remove_suid.generic_file_w=
rite_iter.new_sync_write.vfs_write.sys_pwrite64": [=0A    0,=0A    0,=0A   =
 0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.security_=
compute_sid.security_transition_sid.may_create.selinux_inode_create.securit=
y_inode_create": [=0A    0,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.final_putname.putname.do_sys_open.sys_open.sy=
stem_call_fastpath": [=0A    0,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A=
  ],=0A  "perf-profile.cpu-cycles.mntput.path_openat.do_filp_open.do_sys_op=
en.sys_open": [=0A    0,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.sys_close.system_call_fastpath.close": [=0A    0,=0A    0=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_charge_statisti=
cs.isra.20.mem_cgroup_charge_file.__add_to_page_cache_locked.add_to_page_ca=
che_lru.pagecache_get_page": [=0A    0,=0A    0,=0A    0.01,=0A    0.01,=0A=
    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_try_charge_mm.__add=
_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.grab_cache_p=
age_write_begin": [=0A    0,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ]=
,=0A  "perf-profile.cpu-cycles.__mark_inode_dirty.update_time.touch_atime.i=
terate_dir.sys_getdents": [=0A    0,=0A    0,=0A    0.01,=0A    0,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles._IO_default_uflow": [=0A    0,=0A   =
 0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.cmd_record._start.main._=
_libc_start_main": [=0A    0,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "s=
oftirqs.CPU12.NET_TX": [=0A    0,=0A    0,=0A    0,=0A    1=0A  ],=0A  "per=
f-profile.cpu-cycles.__fsnotify_parent.sys_openat.system_call_fastpath": [=
=0A    0,=0A    0,=0A    0,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.=
destroy_inode.evict.iput.do_unlinkat.sys_unlink": [=0A    0,=0A    0,=0A   =
 0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__fd_install.fd_install.=
do_sys_open.sys_open.system_call_fastpath": [=0A    0,=0A    0,=0A    0,=0A=
    0.01=0A  ],=0A  "perf-profile.cpu-cycles.release_pages.pagevec_lru_move=
_fn.lru_add_drain_cpu.__pagevec_release.truncate_inode_pages_range": [=0A  =
  0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.get_p=
artial_node.isra.49.__slab_alloc.kmem_cache_alloc.get_empty_filp.path_opena=
t": [=0A    0,=0A    0,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.fsync": [=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A =
 "turbostat.%c3": [=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "numa-=
meminfo.node0.Writeback": [=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "=
numa-vmstat.node0.nr_writeback": [=0A    0,=0A    0,=0A    0,=0A    0,=0A  =
  0=0A  ],=0A  "softirqs.CPU16.NET_TX": [=0A    0,=0A    0,=0A    0,=0A    =
0,=0A    1=0A  ],=0A  "softirqs.CPU38.TASKLET": [=0A    0,=0A    0,=0A    0=
,=0A    0,=0A    2=0A  ],=0A  "softirqs.CPU39.TASKLET": [=0A    0,=0A    0,=
=0A    0,=0A    0,=0A    1=0A  ],=0A  "perf-profile.cpu-cycles.do_sys_open.=
system_call_fastpath.open64": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=
=2E01=0A  ],=0A  "perf-profile.cpu-cycles.handle_dots.path_openat.do_filp_o=
pen.do_sys_open.sys_openat": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles.lockref_mark_dead.dput.terminate_wal=
k.path_lookupat.filename_lookup": [=0A    0,=0A    0,=0A    0,=0A    0,=0A =
   0.01=0A  ],=0A  "perf-profile.cpu-cycles.__d_free.kthread.ret_from_fork"=
: [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.__sb_start_write.do_last.path_openat.do_filp_open.do_sys_open=
": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profil=
e.cpu-cycles.from_kgid_munged.SYSC_newfstat.sys_newfstat.system_call_fastpa=
th.__fxstat64": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A =
 "perf-profile.cpu-cycles.lookup_page_cgroup.mem_cgroup_charge_file.__add_t=
o_page_cache_locked.add_to_page_cache_lru.pagecache_get_page": [=0A    0,=
=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.=
radix_tree_node_ctor.new_slab.__slab_alloc.kmem_cache_alloc.__radix_tree_pr=
eload": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ]=0A}
--pWyiEgJYm5f9v55/
Content-Type: application/json
Content-Disposition: attachment; filename="bb0b6d-matrix.json"
Content-Transfer-Encoding: quoted-printable

{=0A  "time.user_time": [=0A    9344.18,=0A    9420.05,=0A    9322.26,=0A  =
  9188.36,=0A    9235.32=0A  ],=0A  "time.system_time": [=0A    23055.78,=
=0A    23289.22,=0A    23720.43,=0A    23537.74,=0A    23215.58=0A  ],=0A  =
"time.percent_of_cpu_this_job_got": [=0A    4498,=0A    4541,=0A    4587,=
=0A    4543,=0A    4505=0A  ],=0A  "time.elapsed_time": [=0A    720.25,=0A =
   720.27,=0A    720.27,=0A    720.26,=0A    720.27=0A  ],=0A  "time.maximu=
m_resident_set_size": [=0A    2648,=0A    2680,=0A    2736,=0A    2768,=0A =
   2716=0A  ],=0A  "time.minor_page_faults": [=0A    2544097,=0A    1220989=
,=0A    404071,=0A    1417321,=0A    2325068=0A  ],=0A  "time.voluntary_con=
text_switches": [=0A    2214356,=0A    913226,=0A    215212,=0A    1113242,=
=0A    1987136=0A  ],=0A  "time.involuntary_context_switches": [=0A    1413=
923,=0A    1430296,=0A    1465866,=0A    1407269,=0A    1411604=0A  ],=0A  =
"time.file_system_outputs": [=0A    280,=0A    288,=0A    288,=0A    288,=
=0A    288=0A  ],=0A  "time.page_size": [=0A    4096,=0A    4096,=0A    409=
6,=0A    4096,=0A    4096=0A  ],=0A  "softirqs.CPU0.HI": [=0A    4,=0A    5=
,=0A    5,=0A    5,=0A    5=0A  ],=0A  "softirqs.CPU1.HI": [=0A    2=0A  ],=
=0A  "softirqs.HI": [=0A    6,=0A    5,=0A    5,=0A    5,=0A    5=0A  ],=0A=
  "softirqs.CPU0.TIMER": [=0A    358630,=0A    361417,=0A    364989,=0A    =
360500,=0A    363019=0A  ],=0A  "softirqs.CPU1.TIMER": [=0A    358498,=0A  =
  361038,=0A    365067,=0A    360371,=0A    360840=0A  ],=0A  "softirqs.CPU=
2.TIMER": [=0A    358314,=0A    360537,=0A    364824,=0A    359997,=0A    3=
60853=0A  ],=0A  "softirqs.CPU3.TIMER": [=0A    357663,=0A    360366,=0A   =
 364480,=0A    360251,=0A    360624=0A  ],=0A  "softirqs.CPU4.TIMER": [=0A =
   357942,=0A    360123,=0A    363701,=0A    360046,=0A    360229=0A  ],=0A=
  "softirqs.CPU5.TIMER": [=0A    358136,=0A    360242,=0A    364222,=0A    =
360238,=0A    360562=0A  ],=0A  "softirqs.CPU6.TIMER": [=0A    357975,=0A  =
  360242,=0A    363935,=0A    359412,=0A    359862=0A  ],=0A  "softirqs.CPU=
7.TIMER": [=0A    357547,=0A    359643,=0A    364157,=0A    359787,=0A    3=
59672=0A  ],=0A  "softirqs.CPU8.TIMER": [=0A    357868,=0A    359926,=0A   =
 363920,=0A    359558,=0A    359994=0A  ],=0A  "softirqs.CPU9.TIMER": [=0A =
   357393,=0A    360184,=0A    363978,=0A    359328,=0A    359564=0A  ],=0A=
  "softirqs.CPU10.TIMER": [=0A    357375,=0A    359147,=0A    363998,=0A   =
 359896,=0A    360012=0A  ],=0A  "softirqs.CPU11.TIMER": [=0A    357174,=0A=
    359734,=0A    363952,=0A    359602,=0A    359861=0A  ],=0A  "softirqs.C=
PU12.TIMER": [=0A    352971,=0A    356797,=0A    364993,=0A    357203,=0A  =
  357690=0A  ],=0A  "softirqs.CPU13.TIMER": [=0A    352776,=0A    356552,=
=0A    363122,=0A    356754,=0A    355598=0A  ],=0A  "softirqs.CPU14.TIMER"=
: [=0A    359320,=0A    358089,=0A    363714,=0A    358954,=0A    355408=0A=
  ],=0A  "softirqs.CPU15.TIMER": [=0A    352944,=0A    356920,=0A    363483=
,=0A    357958,=0A    354190=0A  ],=0A  "softirqs.CPU16.TIMER": [=0A    353=
143,=0A    356503,=0A    363665,=0A    355682,=0A    354385=0A  ],=0A  "sof=
tirqs.CPU17.TIMER": [=0A    351144,=0A    358284,=0A    363446,=0A    35606=
2,=0A    352403=0A  ],=0A  "softirqs.CPU18.TIMER": [=0A    351612,=0A    35=
5575,=0A    362872,=0A    356930,=0A    354246=0A  ],=0A  "softirqs.CPU19.T=
IMER": [=0A    351186,=0A    355395,=0A    362786,=0A    355971,=0A    3539=
97=0A  ],=0A  "softirqs.CPU20.TIMER": [=0A    351375,=0A    358863,=0A    3=
62877,=0A    355704,=0A    355085=0A  ],=0A  "softirqs.CPU21.TIMER": [=0A  =
  350855,=0A    355927,=0A    365740,=0A    355773,=0A    353499=0A  ],=0A =
 "softirqs.CPU22.TIMER": [=0A    351644,=0A    355535,=0A    362767,=0A    =
356221,=0A    352602=0A  ],=0A  "softirqs.CPU23.TIMER": [=0A    352589,=0A =
   355210,=0A    366135,=0A    355509,=0A    353165=0A  ],=0A  "softirqs.CP=
U24.TIMER": [=0A    355984,=0A    359528,=0A    363955,=0A    358643,=0A   =
 358965=0A  ],=0A  "softirqs.CPU25.TIMER": [=0A    357325,=0A    360582,=0A=
    364755,=0A    359781,=0A    359455=0A  ],=0A  "softirqs.CPU26.TIMER": [=
=0A    356573,=0A    359176,=0A    363602,=0A    359251,=0A    359754=0A  ]=
,=0A  "softirqs.CPU27.TIMER": [=0A    356312,=0A    359559,=0A    364412,=
=0A    358974,=0A    358643=0A  ],=0A  "softirqs.CPU28.TIMER": [=0A    3570=
55,=0A    359616,=0A    364162,=0A    358861,=0A    359338=0A  ],=0A  "soft=
irqs.CPU29.TIMER": [=0A    356657,=0A    359693,=0A    363058,=0A    359243=
,=0A    359027=0A  ],=0A  "softirqs.CPU30.TIMER": [=0A    356662,=0A    359=
321,=0A    363240,=0A    359147,=0A    359084=0A  ],=0A  "softirqs.CPU31.TI=
MER": [=0A    356591,=0A    359567,=0A    363774,=0A    358576,=0A    35894=
2=0A  ],=0A  "softirqs.CPU32.TIMER": [=0A    355891,=0A    359274,=0A    36=
3947,=0A    358814,=0A    358982=0A  ],=0A  "softirqs.CPU33.TIMER": [=0A   =
 356294,=0A    358951,=0A    363003,=0A    358624,=0A    358905=0A  ],=0A  =
"softirqs.CPU34.TIMER": [=0A    355903,=0A    359542,=0A    363169,=0A    3=
58328,=0A    358228=0A  ],=0A  "softirqs.CPU35.TIMER": [=0A    356323,=0A  =
  359592,=0A    362709,=0A    358480,=0A    359175=0A  ],=0A  "softirqs.CPU=
36.TIMER": [=0A    350267,=0A    355916,=0A    362435,=0A    355318,=0A    =
352289=0A  ],=0A  "softirqs.CPU37.TIMER": [=0A    350897,=0A    355872,=0A =
   363678,=0A    354437,=0A    351403=0A  ],=0A  "softirqs.CPU38.TIMER": [=
=0A    350111,=0A    355210,=0A    362990,=0A    355700,=0A    352941=0A  ]=
,=0A  "softirqs.CPU39.TIMER": [=0A    350161,=0A    355058,=0A    362442,=
=0A    354328,=0A    353589=0A  ],=0A  "softirqs.CPU40.TIMER": [=0A    3487=
70,=0A    356123,=0A    362465,=0A    354660,=0A    352683=0A  ],=0A  "soft=
irqs.CPU41.TIMER": [=0A    350444,=0A    354303,=0A    362147,=0A    354390=
,=0A    351680=0A  ],=0A  "softirqs.CPU42.TIMER": [=0A    349415,=0A    355=
884,=0A    362507,=0A    354602,=0A    351647=0A  ],=0A  "softirqs.CPU43.TI=
MER": [=0A    348965,=0A    356416,=0A    362777,=0A    354374,=0A    35243=
1=0A  ],=0A  "softirqs.CPU44.TIMER": [=0A    348743,=0A    355551,=0A    36=
2671,=0A    353224,=0A    351171=0A  ],=0A  "softirqs.CPU45.TIMER": [=0A   =
 349149,=0A    355501,=0A    362501,=0A    354487,=0A    351440=0A  ],=0A  =
"softirqs.CPU46.TIMER": [=0A    347949,=0A    354925,=0A    362227,=0A    3=
55179,=0A    352651=0A  ],=0A  "softirqs.CPU47.TIMER": [=0A    348385,=0A  =
  354968,=0A    361952,=0A    353830,=0A    352344=0A  ],=0A  "softirqs.TIM=
ER": [=0A    16996913,=0A    17182389,=0A    17451413,=0A    17158970,=0A  =
  17112140=0A  ],=0A  "softirqs.CPU0.NET_TX": [=0A    96,=0A    93,=0A    9=
2,=0A    92,=0A    97=0A  ],=0A  "softirqs.CPU2.NET_TX": [=0A    1=0A  ],=
=0A  "softirqs.CPU37.NET_TX": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=
=0A  ],=0A  "softirqs.NET_TX": [=0A    98,=0A    95,=0A    94,=0A    94,=0A=
    99=0A  ],=0A  "softirqs.CPU0.NET_RX": [=0A    2209,=0A    2344,=0A    2=
116,=0A    2338,=0A    2054=0A  ],=0A  "softirqs.NET_RX": [=0A    2209,=0A =
   2344,=0A    2116,=0A    2338,=0A    2054=0A  ],=0A  "softirqs.CPU0.TASKL=
ET": [=0A    212,=0A    224,=0A    215,=0A    219,=0A    222=0A  ],=0A  "so=
ftirqs.CPU1.TASKLET": [=0A    4,=0A    1,=0A    5,=0A    0,=0A    1=0A  ],=
=0A  "softirqs.CPU2.TASKLET": [=0A    4,=0A    1,=0A    5=0A  ],=0A  "softi=
rqs.CPU3.TASKLET": [=0A    2,=0A    1,=0A    3,=0A    0,=0A    1=0A  ],=0A =
 "softirqs.CPU4.TASKLET": [=0A    1,=0A    0,=0A    1,=0A    0,=0A    1=0A =
 ],=0A  "softirqs.CPU7.TASKLET": [=0A    1,=0A    2,=0A    2,=0A    0,=0A  =
  2=0A  ],=0A  "softirqs.CPU12.TASKLET": [=0A    1=0A  ],=0A  "softirqs.CPU=
13.TASKLET": [=0A    1,=0A    0,=0A    0,=0A    1=0A  ],=0A  "softirqs.CPU1=
4.TASKLET": [=0A    3,=0A    2,=0A    0,=0A    2,=0A    2=0A  ],=0A  "softi=
rqs.CPU15.TASKLET": [=0A    2,=0A    1,=0A    0,=0A    3,=0A    1=0A  ],=0A=
  "softirqs.CPU16.TASKLET": [=0A    1,=0A    1,=0A    0,=0A    3,=0A    1=
=0A  ],=0A  "softirqs.CPU17.TASKLET": [=0A    3,=0A    0,=0A    0,=0A    2=
=0A  ],=0A  "softirqs.CPU18.TASKLET": [=0A    1,=0A    0,=0A    0,=0A    2=
=0A  ],=0A  "softirqs.CPU19.TASKLET": [=0A    1,=0A    0,=0A    0,=0A    2=
=0A  ],=0A  "softirqs.CPU20.TASKLET": [=0A    1,=0A    0,=0A    0,=0A    3=
=0A  ],=0A  "softirqs.CPU21.TASKLET": [=0A    1,=0A    0,=0A    1,=0A    1=
=0A  ],=0A  "softirqs.CPU22.TASKLET": [=0A    1,=0A    0,=0A    0,=0A    1=
=0A  ],=0A  "softirqs.CPU23.TASKLET": [=0A    1,=0A    0,=0A    0,=0A    1=
=0A  ],=0A  "softirqs.CPU25.TASKLET": [=0A    360,=0A    0,=0A    0,=0A    =
360=0A  ],=0A  "softirqs.CPU37.TASKLET": [=0A    2,=0A    361,=0A    361,=
=0A    2,=0A    361=0A  ],=0A  "softirqs.CPU38.TASKLET": [=0A    1,=0A    0=
,=0A    0=0A  ],=0A  "softirqs.TASKLET": [=0A    605,=0A    605,=0A    606,=
=0A    603,=0A    605=0A  ],=0A  "softirqs.CPU0.SCHED": [=0A    9978,=0A   =
 6612,=0A    5841,=0A    7183,=0A    10010=0A  ],=0A  "softirqs.CPU1.SCHED"=
: [=0A    9250,=0A    6242,=0A    5609,=0A    6637,=0A    8710=0A  ],=0A  "=
softirqs.CPU2.SCHED": [=0A    8728,=0A    5657,=0A    5487,=0A    6247,=0A =
   9118=0A  ],=0A  "softirqs.CPU3.SCHED": [=0A    8581,=0A    5567,=0A    4=
994,=0A    6173,=0A    8629=0A  ],=0A  "softirqs.CPU4.SCHED": [=0A    8675,=
=0A    5565,=0A    5034,=0A    6130,=0A    8480=0A  ],=0A  "softirqs.CPU5.S=
CHED": [=0A    8655,=0A    5491,=0A    4924,=0A    6123,=0A    8454=0A  ],=
=0A  "softirqs.CPU6.SCHED": [=0A    8561,=0A    5406,=0A    5000,=0A    614=
0,=0A    8562=0A  ],=0A  "softirqs.CPU7.SCHED": [=0A    8507,=0A    5497,=
=0A    4784,=0A    5955,=0A    8501=0A  ],=0A  "softirqs.CPU8.SCHED": [=0A =
   8524,=0A    5484,=0A    4833,=0A    6009,=0A    8402=0A  ],=0A  "softirq=
s.CPU9.SCHED": [=0A    8612,=0A    5407,=0A    4887,=0A    5997,=0A    8405=
=0A  ],=0A  "softirqs.CPU10.SCHED": [=0A    8429,=0A    5595,=0A    4868,=
=0A    6133,=0A    8357=0A  ],=0A  "softirqs.CPU11.SCHED": [=0A    8525,=0A=
    5430,=0A    4897,=0A    6061,=0A    8468=0A  ],=0A  "softirqs.CPU12.SCH=
ED": [=0A    9448,=0A    6439,=0A    5037,=0A    6493,=0A    10914=0A  ],=
=0A  "softirqs.CPU13.SCHED": [=0A    9343,=0A    6309,=0A    4918,=0A    66=
71,=0A    9658=0A  ],=0A  "softirqs.CPU14.SCHED": [=0A    11242,=0A    6733=
,=0A    4855,=0A    7061,=0A    9829=0A  ],=0A  "softirqs.CPU15.SCHED": [=
=0A    9776,=0A    6358,=0A    5055,=0A    7762,=0A    9866=0A  ],=0A  "sof=
tirqs.CPU16.SCHED": [=0A    9340,=0A    6383,=0A    4819,=0A    6790,=0A   =
 9718=0A  ],=0A  "softirqs.CPU17.SCHED": [=0A    9537,=0A    6892,=0A    47=
53,=0A    6638,=0A    9001=0A  ],=0A  "softirqs.CPU18.SCHED": [=0A    9470,=
=0A    6482,=0A    4973,=0A    6470,=0A    9931=0A  ],=0A  "softirqs.CPU19.=
SCHED": [=0A    9711,=0A    6470,=0A    4969,=0A    6697,=0A    9749=0A  ],=
=0A  "softirqs.CPU20.SCHED": [=0A    9477,=0A    6942,=0A    4790,=0A    67=
50,=0A    9964=0A  ],=0A  "softirqs.CPU21.SCHED": [=0A    9547,=0A    6530,=
=0A    4056,=0A    6619,=0A    9724=0A  ],=0A  "softirqs.CPU22.SCHED": [=0A=
    9292,=0A    6563,=0A    4871,=0A    6738,=0A    9895=0A  ],=0A  "softir=
qs.CPU23.SCHED": [=0A    9426,=0A    6460,=0A    5992,=0A    6601,=0A    98=
19=0A  ],=0A  "softirqs.CPU24.SCHED": [=0A    8472,=0A    5335,=0A    4682,=
=0A    5938,=0A    8345=0A  ],=0A  "softirqs.CPU25.SCHED": [=0A    8962,=0A=
    5963,=0A    5338,=0A    6540,=0A    8687=0A  ],=0A  "softirqs.CPU26.SCH=
ED": [=0A    8446,=0A    5557,=0A    4911,=0A    5970,=0A    8366=0A  ],=0A=
  "softirqs.CPU27.SCHED": [=0A    8504,=0A    5521,=0A    4845,=0A    6156,=
=0A    8499=0A  ],=0A  "softirqs.CPU28.SCHED": [=0A    8352,=0A    5424,=0A=
    4718,=0A    5976,=0A    8310=0A  ],=0A  "softirqs.CPU29.SCHED": [=0A   =
 8411,=0A    5439,=0A    4936,=0A    6046,=0A    8255=0A  ],=0A  "softirqs.=
CPU30.SCHED": [=0A    8331,=0A    5459,=0A    4911,=0A    6078,=0A    8254=
=0A  ],=0A  "softirqs.CPU31.SCHED": [=0A    8343,=0A    5442,=0A    4768,=
=0A    6058,=0A    8372=0A  ],=0A  "softirqs.CPU32.SCHED": [=0A    8444,=0A=
    5538,=0A    4668,=0A    6109,=0A    8243=0A  ],=0A  "softirqs.CPU33.SCH=
ED": [=0A    8439,=0A    5508,=0A    4925,=0A    6069,=0A    8282=0A  ],=0A=
  "softirqs.CPU34.SCHED": [=0A    8432,=0A    5530,=0A    4912,=0A    6101,=
=0A    8270=0A  ],=0A  "softirqs.CPU35.SCHED": [=0A    8250,=0A    5463,=0A=
    5020,=0A    5968,=0A    8277=0A  ],=0A  "softirqs.CPU36.SCHED": [=0A   =
 9246,=0A    6063,=0A    4876,=0A    6551,=0A    9817=0A  ],=0A  "softirqs.=
CPU37.SCHED": [=0A    10070,=0A    6923,=0A    5187,=0A    7407,=0A    1068=
6=0A  ],=0A  "softirqs.CPU38.SCHED": [=0A    9376,=0A    6565,=0A    4856,=
=0A    6814,=0A    9787=0A  ],=0A  "softirqs.CPU39.SCHED": [=0A    9136,=0A=
    6372,=0A    4889,=0A    6838,=0A    9433=0A  ],=0A  "softirqs.CPU40.SCH=
ED": [=0A    9710,=0A    6379,=0A    4766,=0A    6766,=0A    9547=0A  ],=0A=
  "softirqs.CPU41.SCHED": [=0A    9260,=0A    6404,=0A    4937,=0A    6690,=
=0A    9586=0A  ],=0A  "softirqs.CPU42.SCHED": [=0A    9210,=0A    6040,=0A=
    4866,=0A    6598,=0A    9709=0A  ],=0A  "softirqs.CPU43.SCHED": [=0A   =
 9315,=0A    5965,=0A    4700,=0A    6811,=0A    9369=0A  ],=0A  "softirqs.=
CPU44.SCHED": [=0A    9497,=0A    6216,=0A    4733,=0A    6885,=0A    9714=
=0A  ],=0A  "softirqs.CPU45.SCHED": [=0A    9396,=0A    6173,=0A    4801,=
=0A    6597,=0A    9390=0A  ],=0A  "softirqs.CPU46.SCHED": [=0A    9508,=0A=
    6146,=0A    4772,=0A    6578,=0A    9341=0A  ],=0A  "softirqs.CPU47.SCH=
ED": [=0A    9168,=0A    6090,=0A    4815,=0A    6515,=0A    9994=0A  ],=0A=
  "softirqs.SCHED": [=0A    434924,=0A    288042,=0A    237090,=0A    31015=
1,=0A    438707=0A  ],=0A  "softirqs.CPU0.HRTIMER": [=0A    16,=0A    5,=0A=
    1,=0A    7,=0A    13=0A  ],=0A  "softirqs.CPU1.HRTIMER": [=0A    17,=0A=
    10,=0A    0,=0A    9,=0A    15=0A  ],=0A  "softirqs.CPU2.HRTIMER": [=0A=
    11,=0A    9,=0A    4,=0A    6,=0A    23=0A  ],=0A  "softirqs.CPU3.HRTIM=
ER": [=0A    16,=0A    7,=0A    2,=0A    9,=0A    15=0A  ],=0A  "softirqs.C=
PU4.HRTIMER": [=0A    9,=0A    5,=0A    2,=0A    6,=0A    10=0A  ],=0A  "so=
ftirqs.CPU5.HRTIMER": [=0A    9,=0A    5,=0A    2,=0A    6,=0A    16=0A  ],=
=0A  "softirqs.CPU6.HRTIMER": [=0A    14,=0A    7,=0A    4,=0A    5,=0A    =
11=0A  ],=0A  "softirqs.CPU7.HRTIMER": [=0A    13,=0A    6,=0A    2,=0A    =
9,=0A    14=0A  ],=0A  "softirqs.CPU8.HRTIMER": [=0A    13,=0A    6,=0A    =
2,=0A    7,=0A    10=0A  ],=0A  "softirqs.CPU9.HRTIMER": [=0A    14,=0A    =
4,=0A    0,=0A    8,=0A    11=0A  ],=0A  "softirqs.CPU10.HRTIMER": [=0A    =
11,=0A    4,=0A    0,=0A    2,=0A    9=0A  ],=0A  "softirqs.CPU11.HRTIMER":=
 [=0A    9,=0A    7,=0A    3,=0A    4,=0A    6=0A  ],=0A  "softirqs.CPU12.H=
RTIMER": [=0A    13,=0A    8,=0A    1,=0A    9,=0A    7=0A  ],=0A  "softirq=
s.CPU13.HRTIMER": [=0A    12,=0A    6,=0A    1,=0A    5,=0A    13=0A  ],=0A=
  "softirqs.CPU14.HRTIMER": [=0A    8,=0A    4,=0A    1,=0A    9,=0A    16=
=0A  ],=0A  "softirqs.CPU15.HRTIMER": [=0A    20,=0A    16,=0A    1,=0A    =
11,=0A    8=0A  ],=0A  "softirqs.CPU16.HRTIMER": [=0A    16,=0A    8,=0A   =
 6,=0A    3,=0A    14=0A  ],=0A  "softirqs.CPU17.HRTIMER": [=0A    18,=0A  =
  3,=0A    2,=0A    6,=0A    10=0A  ],=0A  "softirqs.CPU18.HRTIMER": [=0A  =
  13,=0A    3,=0A    7,=0A    8,=0A    12=0A  ],=0A  "softirqs.CPU19.HRTIME=
R": [=0A    12,=0A    4,=0A    1,=0A    6,=0A    13=0A  ],=0A  "softirqs.CP=
U20.HRTIMER": [=0A    15,=0A    6,=0A    0,=0A    8,=0A    13=0A  ],=0A  "s=
oftirqs.CPU21.HRTIMER": [=0A    10,=0A    8,=0A    2,=0A    6,=0A    12=0A =
 ],=0A  "softirqs.CPU22.HRTIMER": [=0A    14,=0A    6,=0A    2,=0A    8,=0A=
    13=0A  ],=0A  "softirqs.CPU23.HRTIMER": [=0A    14,=0A    5,=0A    2,=
=0A    8,=0A    12=0A  ],=0A  "softirqs.CPU24.HRTIMER": [=0A    9,=0A    7,=
=0A    0,=0A    4,=0A    7=0A  ],=0A  "softirqs.CPU25.HRTIMER": [=0A    17,=
=0A    6,=0A    3,=0A    8,=0A    16=0A  ],=0A  "softirqs.CPU26.HRTIMER": [=
=0A    17,=0A    3,=0A    2,=0A    10,=0A    14=0A  ],=0A  "softirqs.CPU27.=
HRTIMER": [=0A    9,=0A    2,=0A    1,=0A    11,=0A    13=0A  ],=0A  "softi=
rqs.CPU28.HRTIMER": [=0A    10,=0A    9,=0A    3,=0A    8,=0A    12=0A  ],=
=0A  "softirqs.CPU29.HRTIMER": [=0A    13,=0A    3,=0A    2,=0A    6,=0A   =
 15=0A  ],=0A  "softirqs.CPU30.HRTIMER": [=0A    10,=0A    7,=0A    1,=0A  =
  5,=0A    9=0A  ],=0A  "softirqs.CPU31.HRTIMER": [=0A    12,=0A    6,=0A  =
  1,=0A    5,=0A    10=0A  ],=0A  "softirqs.CPU32.HRTIMER": [=0A    13,=0A =
   2,=0A    1,=0A    4,=0A    10=0A  ],=0A  "softirqs.CPU33.HRTIMER": [=0A =
   11,=0A    7,=0A    0,=0A    6,=0A    14=0A  ],=0A  "softirqs.CPU34.HRTIM=
ER": [=0A    11,=0A    2,=0A    1,=0A    6,=0A    12=0A  ],=0A  "softirqs.C=
PU35.HRTIMER": [=0A    15,=0A    6,=0A    0,=0A    11,=0A    12=0A  ],=0A  =
"softirqs.CPU36.HRTIMER": [=0A    14,=0A    6,=0A    3,=0A    8,=0A    10=
=0A  ],=0A  "softirqs.CPU37.HRTIMER": [=0A    22,=0A    8,=0A    4,=0A    9=
,=0A    14=0A  ],=0A  "softirqs.CPU38.HRTIMER": [=0A    9,=0A    6,=0A    4=
,=0A    10,=0A    19=0A  ],=0A  "softirqs.CPU39.HRTIMER": [=0A    13,=0A   =
 7,=0A    2,=0A    9,=0A    15=0A  ],=0A  "softirqs.CPU40.HRTIMER": [=0A   =
 16,=0A    5,=0A    2,=0A    5,=0A    15=0A  ],=0A  "softirqs.CPU41.HRTIMER=
": [=0A    13,=0A    7,=0A    2,=0A    6,=0A    12=0A  ],=0A  "softirqs.CPU=
42.HRTIMER": [=0A    13,=0A    6,=0A    0,=0A    5,=0A    10=0A  ],=0A  "so=
ftirqs.CPU43.HRTIMER": [=0A    16,=0A    6,=0A    2,=0A    7,=0A    10=0A  =
],=0A  "softirqs.CPU44.HRTIMER": [=0A    14,=0A    7,=0A    0,=0A    7,=0A =
   13=0A  ],=0A  "softirqs.CPU45.HRTIMER": [=0A    8,=0A    7,=0A    0,=0A =
   4,=0A    12=0A  ],=0A  "softirqs.CPU46.HRTIMER": [=0A    16,=0A    6,=0A=
    4,=0A    4,=0A    12=0A  ],=0A  "softirqs.CPU47.HRTIMER": [=0A    13,=
=0A    7,=0A    1,=0A    5,=0A    12=0A  ],=0A  "softirqs.HRTIMER": [=0A   =
 638,=0A    301,=0A    100,=0A    340,=0A    604=0A  ],=0A  "softirqs.CPU0.=
RCU": [=0A    64003,=0A    62157,=0A    58506,=0A    60531,=0A    62290=0A =
 ],=0A  "softirqs.CPU1.RCU": [=0A    65890,=0A    64262,=0A    60995,=0A   =
 62322,=0A    63016=0A  ],=0A  "softirqs.CPU2.RCU": [=0A    66034,=0A    63=
995,=0A    61671,=0A    62722,=0A    64421=0A  ],=0A  "softirqs.CPU3.RCU": =
[=0A    65317,=0A    64514,=0A    61034,=0A    62239,=0A    64068=0A  ],=0A=
  "softirqs.CPU4.RCU": [=0A    65266,=0A    64291,=0A    61497,=0A    62566=
,=0A    63628=0A  ],=0A  "softirqs.CPU5.RCU": [=0A    66052,=0A    65267,=
=0A    62323,=0A    63095,=0A    63489=0A  ],=0A  "softirqs.CPU6.RCU": [=0A=
    65480,=0A    65092,=0A    61717,=0A    62697,=0A    63344=0A  ],=0A  "s=
oftirqs.CPU7.RCU": [=0A    65606,=0A    64787,=0A    56750,=0A    63107,=0A=
    61628=0A  ],=0A  "softirqs.CPU8.RCU": [=0A    64784,=0A    63011,=0A   =
 60876,=0A    61433,=0A    61671=0A  ],=0A  "softirqs.CPU9.RCU": [=0A    64=
688,=0A    63764,=0A    60815,=0A    61740,=0A    61567=0A  ],=0A  "softirq=
s.CPU10.RCU": [=0A    64525,=0A    62440,=0A    59815,=0A    61452,=0A    6=
1722=0A  ],=0A  "softirqs.CPU11.RCU": [=0A    64774,=0A    61900,=0A    597=
56,=0A    60715,=0A    61789=0A  ],=0A  "softirqs.CPU12.RCU": [=0A    59756=
,=0A    58691,=0A    56681,=0A    56906,=0A    58597=0A  ],=0A  "softirqs.C=
PU13.RCU": [=0A    59511,=0A    58777,=0A    56009,=0A    56990,=0A    5825=
3=0A  ],=0A  "softirqs.CPU14.RCU": [=0A    60850,=0A    59485,=0A    55330,=
=0A    58323,=0A    58730=0A  ],=0A  "softirqs.CPU15.RCU": [=0A    59722,=
=0A    58796,=0A    56412,=0A    57231,=0A    58270=0A  ],=0A  "softirqs.CP=
U16.RCU": [=0A    61795,=0A    61747,=0A    59842,=0A    60379,=0A    61048=
=0A  ],=0A  "softirqs.CPU17.RCU": [=0A    61703,=0A    62826,=0A    59240,=
=0A    60114,=0A    61649=0A  ],=0A  "softirqs.CPU18.RCU": [=0A    61950,=
=0A    62357,=0A    58779,=0A    60867,=0A    61510=0A  ],=0A  "softirqs.CP=
U19.RCU": [=0A    61838,=0A    61481,=0A    59817,=0A    60278,=0A    60763=
=0A  ],=0A  "softirqs.CPU20.RCU": [=0A    61471,=0A    61764,=0A    59426,=
=0A    59814,=0A    60582=0A  ],=0A  "softirqs.CPU21.RCU": [=0A    61747,=
=0A    61868,=0A    61517,=0A    60299,=0A    60948=0A  ],=0A  "softirqs.CP=
U22.RCU": [=0A    62021,=0A    60395,=0A    58908,=0A    59756,=0A    60689=
=0A  ],=0A  "softirqs.CPU23.RCU": [=0A    61545,=0A    60186,=0A    60896,=
=0A    59654,=0A    60941=0A  ],=0A  "softirqs.CPU24.RCU": [=0A    64420,=
=0A    63033,=0A    60647,=0A    60796,=0A    62693=0A  ],=0A  "softirqs.CP=
U25.RCU": [=0A    65209,=0A    64554,=0A    60907,=0A    61808,=0A    63132=
=0A  ],=0A  "softirqs.CPU26.RCU": [=0A    64576,=0A    63025,=0A    60474,=
=0A    61640,=0A    63670=0A  ],=0A  "softirqs.CPU27.RCU": [=0A    64336,=
=0A    63535,=0A    61299,=0A    61294,=0A    62779=0A  ],=0A  "softirqs.CP=
U28.RCU": [=0A    64949,=0A    64383,=0A    61332,=0A    61565,=0A    65274=
=0A  ],=0A  "softirqs.CPU29.RCU": [=0A    64240,=0A    64031,=0A    58457,=
=0A    62029,=0A    62738=0A  ],=0A  "softirqs.CPU30.RCU": [=0A    64040,=
=0A    64575,=0A    60024,=0A    61968,=0A    62110=0A  ],=0A  "softirqs.CP=
U31.RCU": [=0A    64247,=0A    64802,=0A    60826,=0A    61385,=0A    60373=
=0A  ],=0A  "softirqs.CPU32.RCU": [=0A    61223,=0A    60015,=0A    57921,=
=0A    59377,=0A    58715=0A  ],=0A  "softirqs.CPU33.RCU": [=0A    61534,=
=0A    60104,=0A    57768,=0A    58914,=0A    59954=0A  ],=0A  "softirqs.CP=
U34.RCU": [=0A    61561,=0A    60169,=0A    56953,=0A    58943,=0A    59619=
=0A  ],=0A  "softirqs.CPU35.RCU": [=0A    61962,=0A    60272,=0A    57118,=
=0A    57976,=0A    59677=0A  ],=0A  "softirqs.CPU36.RCU": [=0A    61919,=
=0A    62028,=0A    58662,=0A    59924,=0A    60052=0A  ],=0A  "softirqs.CP=
U37.RCU": [=0A    62188,=0A    61985,=0A    61295,=0A    60371,=0A    60625=
=0A  ],=0A  "softirqs.CPU38.RCU": [=0A    62719,=0A    62080,=0A    59978,=
=0A    60669,=0A    64372=0A  ],=0A  "softirqs.CPU39.RCU": [=0A    62654,=
=0A    62886,=0A    59952,=0A    60710,=0A    62667=0A  ],=0A  "softirqs.CP=
U40.RCU": [=0A    62427,=0A    63405,=0A    61224,=0A    61964,=0A    62962=
=0A  ],=0A  "softirqs.CPU41.RCU": [=0A    63446,=0A    63392,=0A    59931,=
=0A    61797,=0A    61694=0A  ],=0A  "softirqs.CPU42.RCU": [=0A    63285,=
=0A    63780,=0A    60694,=0A    61681,=0A    61875=0A  ],=0A  "softirqs.CP=
U43.RCU": [=0A    62575,=0A    62933,=0A    61305,=0A    61971,=0A    61661=
=0A  ],=0A  "softirqs.CPU44.RCU": [=0A    61500,=0A    61673,=0A    59812,=
=0A    59419,=0A    59971=0A  ],=0A  "softirqs.CPU45.RCU": [=0A    62183,=
=0A    61682,=0A    59490,=0A    60771,=0A    60354=0A  ],=0A  "softirqs.CP=
U46.RCU": [=0A    62126,=0A    60817,=0A    59688,=0A    60059,=0A    60783=
=0A  ],=0A  "softirqs.CPU47.RCU": [=0A    61939,=0A    61603,=0A    57527,=
=0A    59797,=0A    60476=0A  ],=0A  "softirqs.RCU": [=0A    3027595,=0A   =
 2994624,=0A    2861906,=0A    2912069,=0A    2952852=0A  ],=0A  "uptime.bo=
ot": [=0A    747.15,=0A    746.43,=0A    751.44,=0A    744.0,=0A    748.75=
=0A  ],=0A  "uptime.idle": [=0A    1798.0,=0A    1510.32,=0A    1530.92,=0A=
    1417.76,=0A    1854.55=0A  ],=0A  "perf-profile.cpu-cycles.copy_user_en=
hanced_fast_string.copy_page_to_iter.generic_file_read_iter.new_sync_read.v=
fs_read": [=0A    15.25,=0A    15.28,=0A    15.38,=0A    15.26,=0A    15.15=
=0A  ],=0A  "perf-profile.cpu-cycles.copy_user_enhanced_fast_string.iov_ite=
r_copy_from_user_atomic.generic_perform_write.__generic_file_write_iter.gen=
eric_file_write_iter": [=0A    8.83,=0A    8.65,=0A    8.69,=0A    8.77,=0A=
    8.8=0A  ],=0A  "perf-profile.cpu-cycles.rcu_nocb_kthread.kthread.ret_fr=
om_fork": [=0A    2.21,=0A    2.33,=0A    2.24,=0A    2.21,=0A    2.23=0A  =
],=0A  "perf-profile.cpu-cycles.find_get_entry.pagecache_get_page.generic_f=
ile_read_iter.new_sync_read.vfs_read": [=0A    2.16,=0A    2.09,=0A    2.05=
,=0A    2.12,=0A    2.18=0A  ],=0A  "perf-profile.cpu-cycles.__vdso_gettime=
ofday": [=0A    2.03,=0A    1.99,=0A    1.93,=0A    1.98,=0A    2.05=0A  ],=
=0A  "perf-profile.cpu-cycles.avc_has_perm_noaudit.selinux_inode_permission=
=2Esecurity_inode_permission.__inode_permission.inode_permission": [=0A    =
1.39,=0A    1.45,=0A    1.65,=0A    1.4,=0A    1.44=0A  ],=0A  "perf-profil=
e.cpu-cycles.get_empty_filp.path_openat.do_filp_open.do_sys_open.sys_openat=
": [=0A    1.19,=0A    1.25,=0A    1.23,=0A    1.22,=0A    1.19=0A  ],=0A  =
"perf-profile.cpu-cycles._raw_spin_lock.dcache_readdir.iterate_dir.sys_getd=
ents.system_call_fastpath": [=0A    1.11,=0A    1.09,=0A    1.09,=0A    1.1=
1,=0A    1.13=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_permission.=
security_inode_permission.__inode_permission.inode_permission.link_path_wal=
k": [=0A    1.08,=0A    1.02,=0A    1.03,=0A    1.06,=0A    1.06=0A  ],=0A =
 "perf-profile.cpu-cycles.link_path_walk.path_lookupat.filename_lookup.user=
_path_at_empty.user_path_at": [=0A    0.92,=0A    0.91,=0A    0.92,=0A    0=
=2E95,=0A    0.93=0A  ],=0A  "perf-profile.cpu-cycles.set_page_dirty.simple=
_write_end.generic_perform_write.__generic_file_write_iter.generic_file_wri=
te_iter": [=0A    0.87,=0A    0.88,=0A    0.87,=0A    0.88,=0A    0.89=0A  =
],=0A  "perf-profile.cpu-cycles.simple_write_end.generic_perform_write.__ge=
neric_file_write_iter.generic_file_write_iter.new_sync_write": [=0A    0.82=
,=0A    0.83,=0A    0.83,=0A    0.81,=0A    0.8=0A  ],=0A  "perf-profile.cp=
u-cycles.find_get_entry.pagecache_get_page.grab_cache_page_write_begin.simp=
le_write_begin.generic_perform_write": [=0A    0.81,=0A    0.8,=0A    0.78,=
=0A    0.8,=0A    0.83=0A  ],=0A  "perf-profile.cpu-cycles.close": [=0A    =
0.77,=0A    0.77,=0A    0.77,=0A    0.79,=0A    0.81=0A  ],=0A  "perf-profi=
le.cpu-cycles.get_empty_filp.path_openat.do_filp_open.do_sys_open.sys_open"=
: [=0A    0.76,=0A    0.81,=0A    0.81,=0A    0.79,=0A    0.78=0A  ],=0A  "=
perf-profile.cpu-cycles.__mem_cgroup_uncharge_common.mem_cgroup_uncharge_ca=
che_page.delete_from_page_cache.truncate_inode_page.truncate_inode_pages_ra=
nge": [=0A    0.73,=0A    0.72,=0A    0.72,=0A    0.73,=0A    0.73=0A  ],=
=0A  "perf-profile.cpu-cycles.__d_lookup_rcu.lookup_fast.link_path_walk.pat=
h_lookupat.filename_lookup": [=0A    0.7,=0A    0.69,=0A    0.69,=0A    0.7=
4,=0A    0.76=0A  ],=0A  "perf-profile.cpu-cycles.dcache_readdir.iterate_di=
r.sys_getdents.system_call_fastpath": [=0A    0.68,=0A    0.69,=0A    0.69,=
=0A    0.7,=0A    0.68=0A  ],=0A  "perf-profile.cpu-cycles.__d_lookup_rcu.l=
ookup_fast.path_lookupat.filename_lookup.user_path_at_empty": [=0A    0.63,=
=0A    0.63,=0A    0.62,=0A    0.62,=0A    0.62=0A  ],=0A  "perf-profile.cp=
u-cycles.__d_alloc.d_alloc.dcache_dir_open.do_dentry_open.finish_open": [=
=0A    0.62,=0A    0.63,=0A    0.66,=0A    0.62,=0A    0.63=0A  ],=0A  "per=
f-profile.cpu-cycles.file_free_rcu.rcu_nocb_kthread.kthread.ret_from_fork":=
 [=0A    0.57,=0A    0.71,=0A    0.68,=0A    0.66,=0A    0.65=0A  ],=0A  "p=
erf-profile.cpu-cycles.memchr": [=0A    0.57,=0A    0.64,=0A    0.55,=0A   =
 0.56,=0A    0.58=0A  ],=0A  "perf-profile.cpu-cycles.free_pcppages_bulk.fr=
ee_hot_cold_page.free_hot_cold_page_list.release_pages.__pagevec_release": =
[=0A    0.54,=0A    0.55,=0A    0.54,=0A    0.54,=0A    0.54=0A  ],=0A  "pe=
rf-profile.cpu-cycles.filldir.dcache_readdir.iterate_dir.sys_getdents.syste=
m_call_fastpath": [=0A    0.52,=0A    0.5,=0A    0.51,=0A    0.5,=0A    0.5=
1=0A  ],=0A  "perf-profile.cpu-cycles.readdir64": [=0A    0.51,=0A    0.49,=
=0A    0.49,=0A    0.5,=0A    0.5=0A  ],=0A  "perf-profile.cpu-cycles.d_set=
_d_op.__d_alloc.d_alloc.dcache_dir_open.do_dentry_open": [=0A    0.5,=0A   =
 0.51,=0A    0.5,=0A    0.5,=0A    0.5=0A  ],=0A  "perf-profile.cpu-cycles.=
__mem_cgroup_commit_charge.mem_cgroup_charge_file.__add_to_page_cache_locke=
d.add_to_page_cache_lru.pagecache_get_page": [=0A    0.49,=0A    0.49,=0A  =
  0.5,=0A    0.5,=0A    0.5=0A  ],=0A  "perf-profile.cpu-cycles.do_dentry_o=
pen.finish_open.do_last.path_openat.do_filp_open": [=0A    0.49,=0A    0.47=
,=0A    0.46,=0A    0.47,=0A    0.48=0A  ],=0A  "perf-profile.cpu-cycles.ch=
eck_kill_permission.group_send_sig_info.kill_pid_info.SYSC_kill.sys_kill": =
[=0A    0.48,=0A    0.41,=0A    0.47,=0A    0.4,=0A    0.4=0A  ],=0A  "perf=
-profile.cpu-cycles.__d_free.rcu_nocb_kthread.kthread.ret_from_fork": [=0A =
   0.45,=0A    0.45,=0A    0.46,=0A    0.46,=0A    0.46=0A  ],=0A  "perf-pr=
ofile.cpu-cycles._IO_fgets": [=0A    0.44,=0A    0.46,=0A    0.51,=0A    0.=
42,=0A    0.48=0A  ],=0A  "perf-profile.cpu-cycles.find_get_entries.pagevec=
_lookup_entries.truncate_inode_pages_range.truncate_inode_pages_final.evict=
": [=0A    0.44,=0A    0.45,=0A    0.43,=0A    0.43,=0A    0.44=0A  ],=0A  =
"perf-profile.cpu-cycles.link_path_walk.path_openat.do_filp_open.do_sys_ope=
n.sys_openat": [=0A    0.42,=0A    0.43,=0A    0.43,=0A    0.43,=0A    0.42=
=0A  ],=0A  "perf-profile.cpu-cycles.__radix_tree_lookup.radix_tree_lookup_=
slot.find_get_entry.pagecache_get_page.generic_file_read_iter": [=0A    0.4=
,=0A    0.41,=0A    0.41,=0A    0.4,=0A    0.4=0A  ],=0A  "perf-profile.cpu=
-cycles.__d_lookup_rcu.lookup_fast.link_path_walk.path_openat.do_filp_open"=
: [=0A    0.4,=0A    0.37,=0A    0.38,=0A    0.39,=0A    0.43=0A  ],=0A  "p=
erf-profile.cpu-cycles.malloc": [=0A    0.37,=0A    0.35,=0A    0.34,=0A   =
 0.33,=0A    0.34=0A  ],=0A  "perf-profile.cpu-cycles.__list_add.dcache_rea=
ddir.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.36,=0A    0.=
32,=0A    0.34,=0A    0.34,=0A    0.34=0A  ],=0A  "perf-profile.cpu-cycles.=
_IO_getline_info": [=0A    0.35,=0A    0.34,=0A    0.32,=0A    0.33,=0A    =
0.33=0A  ],=0A  "perf-profile.cpu-cycles.link_path_walk.path_openat.do_filp=
_open.do_sys_open.sys_open": [=0A    0.34,=0A    0.35,=0A    0.34,=0A    0.=
34,=0A    0.35=0A  ],=0A  "perf-profile.cpu-cycles.avc_has_perm.current_has=
_perm.selinux_task_kill.security_task_kill.check_kill_permission": [=0A    =
0.34,=0A    0.34,=0A    0.34,=0A    0.34,=0A    0.34=0A  ],=0A  "perf-profi=
le.cpu-cycles.find_pid_ns.find_vpid.SYSC_kill.sys_kill.system_call_fastpath=
": [=0A    0.34,=0A    0.34,=0A    0.38,=0A    0.33,=0A    0.27=0A  ],=0A  =
"perf-profile.cpu-cycles.generic_permission.__inode_permission.inode_permis=
sion.link_path_walk.path_lookupat": [=0A    0.32,=0A    0.35,=0A    0.32,=
=0A    0.33,=0A    0.32=0A  ],=0A  "perf-profile.cpu-cycles.strchr@plt": [=
=0A    0.32,=0A    0.3,=0A    0.31,=0A    0.3,=0A    0.31=0A  ],=0A  "perf-=
profile.cpu-cycles.__d_alloc.d_alloc.lookup_dcache.__lookup_hash.lookup_slo=
w": [=0A    0.32,=0A    0.34,=0A    0.35,=0A    0.33,=0A    0.32=0A  ],=0A =
 "perf-profile.cpu-cycles.kmem_cache_free.final_putname.putname.user_path_a=
t_empty.user_path_at": [=0A    0.29,=0A    0.26,=0A    0.28,=0A    0.28,=0A=
    0.27=0A  ],=0A  "perf-profile.cpu-cycles.get_page_from_freelist.__alloc=
_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page":=
 [=0A    0.29,=0A    0.29,=0A    0.28,=0A    0.29,=0A    0.29=0A  ],=0A  "p=
erf-profile.cpu-cycles.strtol": [=0A    0.29,=0A    0.27,=0A    0.29,=0A   =
 0.25,=0A    0.26=0A  ],=0A  "perf-profile.cpu-cycles.pid_vnr.SYSC_kill.sys=
_kill.system_call_fastpath.kill": [=0A    0.28,=0A    0.22,=0A    0.22,=0A =
   0.29,=0A    0.23=0A  ],=0A  "perf-profile.cpu-cycles.copy_page_to_iter_i=
ovec.copy_page_to_iter.generic_file_read_iter.new_sync_read.vfs_read": [=0A=
    0.28,=0A    0.28,=0A    0.27,=0A    0.28,=0A    0.28=0A  ],=0A  "perf-p=
rofile.cpu-cycles.generic_file_read_iter.new_sync_read.vfs_read.sys_pread64=
=2Esystem_call_fastpath": [=0A    0.27,=0A    0.27,=0A    0.27,=0A    0.25,=
=0A    0.26=0A  ],=0A  "perf-profile.cpu-cycles.path_init.path_lookupat.fil=
ename_lookup.user_path_at_empty.user_path_at": [=0A    0.27,=0A    0.3,=0A =
   0.27,=0A    0.27,=0A    0.3=0A  ],=0A  "perf-profile.cpu-cycles.kmem_cac=
he_alloc.get_empty_filp.path_openat.do_filp_open.do_sys_open": [=0A    0.27=
,=0A    0.28,=0A    0.26,=0A    0.26,=0A    0.26=0A  ],=0A  "perf-profile.c=
pu-cycles.__fput.____fput.task_work_run.do_notify_resume.int_signal": [=0A =
   0.27,=0A    0.27,=0A    0.26,=0A    0.26,=0A    0.26=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.memset.generic_perform_write.__generic_file_write_iter.gen=
eric_file_write_iter.new_sync_write": [=0A    0.26,=0A    0.27,=0A    0.27,=
=0A    0.27,=0A    0.25=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_unloc=
k.dcache_readdir.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.=
26,=0A    0.26,=0A    0.25,=0A    0.26,=0A    0.26=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.task_work_run.do_notify_resume.int_signal.close": [=0A    0.2=
6,=0A    0.26,=0A    0.26,=0A    0.27,=0A    0.27=0A  ],=0A  "perf-profile.=
cpu-cycles.do_last.path_openat.do_filp_open.do_sys_open.sys_openat": [=0A  =
  0.25,=0A    0.25,=0A    0.27,=0A    0.26,=0A    0.26=0A  ],=0A  "perf-pro=
file.cpu-cycles.kmem_cache_alloc.getname_flags.user_path_at_empty.user_path=
_at.vfs_fstatat": [=0A    0.25,=0A    0.26,=0A    0.23,=0A    0.2,=0A    0.=
24=0A  ],=0A  "perf-profile.cpu-cycles.kfree.selinux_file_free_security.sec=
urity_file_free.__fput.____fput": [=0A    0.24,=0A    0.24,=0A    0.23,=0A =
   0.23,=0A    0.25=0A  ],=0A  "perf-profile.cpu-cycles.do_last.path_openat=
=2Edo_filp_open.do_sys_open.sys_open": [=0A    0.24,=0A    0.25,=0A    0.27=
,=0A    0.24,=0A    0.25=0A  ],=0A  "perf-profile.cpu-cycles.kill": [=0A   =
 0.24,=0A    0.24,=0A    0.24,=0A    0.27,=0A    0.28=0A  ],=0A  "perf-prof=
ile.cpu-cycles.update_cfs_rq_blocked_load.task_tick_fair.scheduler_tick.upd=
ate_process_times.tick_sched_handle": [=0A    0.24,=0A    0.2,=0A    0.22,=
=0A    0.21,=0A    0.23=0A  ],=0A  "perf-profile.cpu-cycles.inode_init_alwa=
ys.alloc_inode.new_inode_pseudo.new_inode.ramfs_get_inode": [=0A    0.23,=
=0A    0.25,=0A    0.25,=0A    0.23,=0A    0.23=0A  ],=0A  "perf-profile.cp=
u-cycles.SYSC_kill.sys_kill.system_call_fastpath.kill": [=0A    0.23,=0A   =
 0.25,=0A    0.23,=0A    0.26,=0A    0.24=0A  ],=0A  "perf-profile.cpu-cycl=
es.generic_permission.__inode_permission.inode_permission.link_path_walk.pa=
th_openat": [=0A    0.23,=0A    0.24,=0A    0.23,=0A    0.23,=0A    0.21=0A=
  ],=0A  "perf-profile.cpu-cycles.__inode_permission.inode_permission.link_=
path_walk.path_lookupat.filename_lookup": [=0A    0.22,=0A    0.22,=0A    0=
=2E22,=0A    0.24,=0A    0.23=0A  ],=0A  "perf-profile.cpu-cycles.__list_de=
l_entry.list_del.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_=
current": [=0A    0.22,=0A    0.22,=0A    0.22,=0A    0.22,=0A    0.23=0A  =
],=0A  "perf-profile.cpu-cycles.cmpxchg_double_slab.isra.51.__slab_free.kme=
m_cache_free.__d_free.rcu_nocb_kthread": [=0A    0.22,=0A    0.24,=0A    0.=
31,=0A    0.22,=0A    0.23=0A  ],=0A  "perf-profile.cpu-cycles.d_set_d_op._=
_d_alloc.d_alloc.lookup_dcache.__lookup_hash": [=0A    0.22,=0A    0.23,=0A=
    0.23,=0A    0.21,=0A    0.22=0A  ],=0A  "perf-profile.cpu-cycles.put_pa=
ge.generic_file_read_iter.new_sync_read.vfs_read.sys_pread64": [=0A    0.21=
,=0A    0.21,=0A    0.22,=0A    0.22,=0A    0.22=0A  ],=0A  "perf-profile.c=
pu-cycles.lookup_fast.link_path_walk.path_lookupat.filename_lookup.user_pat=
h_at_empty": [=0A    0.21,=0A    0.19,=0A    0.2,=0A    0.2,=0A    0.2=0A  =
],=0A  "perf-profile.cpu-cycles.__list_del_entry.list_del.__rmqueue.get_pag=
e_from_freelist.__alloc_pages_nodemask": [=0A    0.2,=0A    0.2,=0A    0.21=
,=0A    0.2,=0A    0.21=0A  ],=0A  "perf-profile.cpu-cycles.system_call_aft=
er_swapgs.kill": [=0A    0.2,=0A    0.2,=0A    0.18,=0A    0.2,=0A    0.19=
=0A  ],=0A  "perf-profile.cpu-cycles.__xstat64": [=0A    0.2,=0A    0.19,=
=0A    0.21,=0A    0.18,=0A    0.17=0A  ],=0A  "perf-profile.cpu-cycles.do_=
sys_open.sys_openat.system_call_fastpath": [=0A    0.2,=0A    0.21,=0A    0=
=2E2,=0A    0.2,=0A    0.19=0A  ],=0A  "perf-profile.cpu-cycles.kmem_cache_=
alloc_trace.selinux_file_alloc_security.security_file_alloc.get_empty_filp.=
path_openat": [=0A    0.19,=0A    0.2,=0A    0.2,=0A    0.17,=0A    0.19=0A=
  ],=0A  "perf-profile.cpu-cycles.__call_rcu_nocb_enqueue.__call_rcu.call_r=
cu_sched.__fput.____fput": [=0A    0.19,=0A    0.18,=0A    0.19,=0A    0.18=
,=0A    0.19=0A  ],=0A  "perf-profile.cpu-cycles.free": [=0A    0.19,=0A   =
 0.21,=0A    0.19,=0A    0.19,=0A    0.2=0A  ],=0A  "perf-profile.cpu-cycle=
s.__ctype_b_loc": [=0A    0.19,=0A    0.17,=0A    0.14,=0A    0.13,=0A    0=
=2E14=0A  ],=0A  "perf-profile.cpu-cycles.path_lookupat.filename_lookup.use=
r_path_at_empty.user_path_at.vfs_fstatat": [=0A    0.19,=0A    0.18,=0A    =
0.19,=0A    0.17,=0A    0.2=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_l=
ock.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.19,=0A    0.1=
9,=0A    0.19,=0A    0.2,=0A    0.18=0A  ],=0A  "perf-profile.cpu-cycles.__=
mnt_want_write.do_dentry_open.finish_open.do_last.path_openat": [=0A    0.1=
8,=0A    0.19,=0A    0.18,=0A    0.18,=0A    0.18=0A  ],=0A  "perf-profile.=
cpu-cycles.kmem_cache_free.__d_free.dentry_free.__dentry_kill.dput": [=0A  =
  0.18,=0A    0.16,=0A    0.16,=0A    0.17,=0A    0.17=0A  ],=0A  "perf-pro=
file.cpu-cycles.inode_has_perm.isra.32.selinux_inode_getattr.security_inode=
_getattr.vfs_getattr.vfs_fstatat": [=0A    0.18,=0A    0.17,=0A    0.17,=0A=
    0.17,=0A    0.16=0A  ],=0A  "perf-profile.cpu-cycles.touch_atime.iterat=
e_dir.sys_getdents.system_call_fastpath": [=0A    0.18,=0A    0.18,=0A    0=
=2E19,=0A    0.17,=0A    0.17=0A  ],=0A  "perf-profile.cpu-cycles.inode_per=
mission.path_lookupat.filename_lookup.user_path_at_empty.user_path_at": [=
=0A    0.18,=0A    0.14,=0A    0.18,=0A    0.2,=0A    0.18=0A  ],=0A  "perf=
-profile.cpu-cycles.__radix_tree_lookup.radix_tree_lookup_slot.find_get_ent=
ry.pagecache_get_page.grab_cache_page_write_begin": [=0A    0.17,=0A    0.1=
7,=0A    0.18,=0A    0.18,=0A    0.18=0A  ],=0A  "perf-profile.cpu-cycles.f=
snotify.security_file_open.do_dentry_open.finish_open.do_last": [=0A    0.1=
7,=0A    0.17,=0A    0.17,=0A    0.18,=0A    0.17=0A  ],=0A  "perf-profile.=
cpu-cycles.lookup_fast.link_path_walk.path_openat.do_filp_open.do_sys_open"=
: [=0A    0.17,=0A    0.17,=0A    0.16,=0A    0.16,=0A    0.16=0A  ],=0A  "=
perf-profile.cpu-cycles.system_call.kill": [=0A    0.17,=0A    0.17,=0A    =
0.16,=0A    0.17,=0A    0.17=0A  ],=0A  "perf-profile.cpu-cycles.generic_fi=
llattr.simple_getattr.vfs_getattr_nosec.vfs_getattr.vfs_fstatat": [=0A    0=
=2E17,=0A    0.2,=0A    0.21,=0A    0.18,=0A    0.17=0A  ],=0A  "perf-profi=
le.cpu-cycles.__call_rcu_nocb_enqueue.__call_rcu.call_rcu_sched.dentry_free=
=2E__dentry_kill": [=0A    0.16,=0A    0.16,=0A    0.16,=0A    0.15,=0A    =
0.16=0A  ],=0A  "perf-profile.cpu-cycles.touch_atime.generic_file_read_iter=
=2Enew_sync_read.vfs_read.sys_pread64": [=0A    0.16,=0A    0.15,=0A    0.1=
5,=0A    0.16,=0A    0.15=0A  ],=0A  "perf-profile.cpu-cycles.avc_has_perm.=
inode_has_perm.selinux_inode_getattr.security_inode_getattr.vfs_getattr": [=
=0A    0.16,=0A    0.14,=0A    0.14,=0A    0.16,=0A    0.17=0A  ],=0A  "per=
f-profile.cpu-cycles.__slab_free.kmem_cache_free.i_callback.rcu_nocb_kthrea=
d.kthread": [=0A    0.16,=0A    0.15,=0A    0.16,=0A    0.17,=0A    0.16=0A=
  ],=0A  "perf-profile.cpu-cycles.__inode_permission.inode_permission.link_=
path_walk.path_openat.do_filp_open": [=0A    0.16,=0A    0.15,=0A    0.16,=
=0A    0.16,=0A    0.16=0A  ],=0A  "perf-profile.cpu-cycles.current_has_per=
m.selinux_task_kill.security_task_kill.check_kill_permission.group_send_sig=
_info": [=0A    0.16,=0A    0.16,=0A    0.15,=0A    0.09,=0A    0.16=0A  ],=
=0A  "perf-profile.cpu-cycles.task_tick_fair.scheduler_tick.update_process_=
times.tick_sched_handle.tick_sched_timer": [=0A    0.16,=0A    0.14,=0A    =
0.15,=0A    0.14,=0A    0.15=0A  ],=0A  "perf-profile.cpu-cycles.__slab_fre=
e.kmem_cache_free.file_free_rcu.rcu_nocb_kthread.kthread": [=0A    0.15,=0A=
    0.16,=0A    0.16,=0A    0.15,=0A    0.15=0A  ],=0A  "perf-profile.cpu-c=
ycles.kmem_cache_alloc.__d_alloc.d_alloc.dcache_dir_open.do_dentry_open": [=
=0A    0.15,=0A    0.12,=0A    0.12,=0A    0.1,=0A    0.12=0A  ],=0A  "perf=
-profile.cpu-cycles.kmem_cache_alloc.__d_alloc.d_alloc.lookup_dcache.__look=
up_hash": [=0A    0.15,=0A    0.12,=0A    0.11,=0A    0.11,=0A    0.11=0A  =
],=0A  "perf-profile.cpu-cycles.__call_rcu.call_rcu_sched.__fput.____fput.t=
ask_work_run": [=0A    0.15,=0A    0.15,=0A    0.15,=0A    0.15,=0A    0.15=
=0A  ],=0A  "perf-profile.cpu-cycles.__wake_up_bit.unlock_page.simple_write=
_end.generic_perform_write.__generic_file_write_iter": [=0A    0.15,=0A    =
0.15,=0A    0.15,=0A    0.15,=0A    0.15=0A  ],=0A  "perf-profile.cpu-cycle=
s.__might_sleep.might_fault.filldir.dcache_readdir.iterate_dir": [=0A    0.=
15,=0A    0.15,=0A    0.15,=0A    0.15,=0A    0.15=0A  ],=0A  "perf-profile=
=2Ecpu-cycles._raw_spin_lock.new_inode_pseudo.new_inode.ramfs_get_inode.ram=
fs_mknod": [=0A    0.14,=0A    0.15,=0A    0.16,=0A    0.15,=0A    0.15=0A =
 ],=0A  "perf-profile.cpu-cycles.iterate_dir.sys_getdents.system_call_fastp=
ath": [=0A    0.14,=0A    0.15,=0A    0.14,=0A    0.15,=0A    0.15=0A  ],=
=0A  "perf-profile.cpu-cycles.generic_perform_write.__generic_file_write_it=
er.generic_file_write_iter.new_sync_write.vfs_write": [=0A    0.14,=0A    0=
=2E13,=0A    0.13,=0A    0.13,=0A    0.13=0A  ],=0A  "perf-profile.cpu-cycl=
es.page_waitqueue.simple_write_end.generic_perform_write.__generic_file_wri=
te_iter.generic_file_write_iter": [=0A    0.14,=0A    0.13,=0A    0.15,=0A =
   0.14,=0A    0.15=0A  ],=0A  "perf-profile.cpu-cycles.strncpy_from_user.g=
etname_flags.user_path_at_empty.user_path_at.vfs_fstatat": [=0A    0.13,=0A=
    0.12,=0A    0.13,=0A    0.13,=0A    0.13=0A  ],=0A  "perf-profile.cpu-c=
ycles.task_work_add.filp_close.__close_fd.sys_close.system_call_fastpath": =
[=0A    0.13,=0A    0.12,=0A    0.12,=0A    0.13,=0A    0.12=0A  ],=0A  "pe=
rf-profile.cpu-cycles.getname_flags.user_path_at_empty.user_path_at.vfs_fst=
atat.SYSC_newstat": [=0A    0.13,=0A    0.13,=0A    0.12,=0A    0.13,=0A   =
 0.13=0A  ],=0A  "perf-profile.cpu-cycles.__fget_light.sys_getdents.system_=
call_fastpath": [=0A    0.12,=0A    0.1,=0A    0.11,=0A    0.13,=0A    0.11=
=0A  ],=0A  "perf-profile.cpu-cycles.memset.get_empty_filp.path_openat.do_f=
ilp_open.do_sys_open": [=0A    0.12,=0A    0.12,=0A    0.13,=0A    0.13,=0A=
    0.12=0A  ],=0A  "perf-profile.cpu-cycles.do_sys_open.sys_open.system_ca=
ll_fastpath.open64": [=0A    0.12,=0A    0.13,=0A    0.13,=0A    0.14,=0A  =
  0.13=0A  ],=0A  "perf-profile.cpu-cycles.__slab_free.kmem_cache_free.__d_=
free.rcu_nocb_kthread.kthread": [=0A    0.12,=0A    0.12,=0A    0.12,=0A   =
 0.12,=0A    0.12=0A  ],=0A  "perf-profile.cpu-cycles.pagecache_get_page.gr=
ab_cache_page_write_begin.simple_write_begin.generic_perform_write.__generi=
c_file_write_iter": [=0A    0.12,=0A    0.11,=0A    0.11,=0A    0.1,=0A    =
0.11=0A  ],=0A  "perf-profile.cpu-cycles.__destroy_inode.destroy_inode.evic=
t.iput.do_unlinkat": [=0A    0.12,=0A    0.13,=0A    0.13,=0A    0.12,=0A  =
  0.12=0A  ],=0A  "perf-profile.cpu-cycles.__list_del_entry.list_del.releas=
e_pages.__pagevec_release.truncate_inode_pages_range": [=0A    0.12,=0A    =
0.12,=0A    0.12,=0A    0.13,=0A    0.12=0A  ],=0A  "perf-profile.cpu-cycle=
s.__fget_light.sys_pread64.system_call_fastpath.pread64": [=0A    0.12,=0A =
   0.09,=0A    0.11,=0A    0.11,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cy=
cles.might_fault.dcache_readdir.iterate_dir.sys_getdents.system_call_fastpa=
th": [=0A    0.11,=0A    0.13,=0A    0.12,=0A    0.13,=0A    0.13=0A  ],=0A=
  "perf-profile.cpu-cycles.kmem_cache_free.final_putname.putname.do_sys_ope=
n.sys_openat": [=0A    0.11,=0A    0.11,=0A    0.11,=0A    0.12,=0A    0.12=
=0A  ],=0A  "perf-profile.cpu-cycles.kmem_cache_alloc.selinux_inode_alloc_s=
ecurity.security_inode_alloc.inode_init_always.alloc_inode": [=0A    0.11,=
=0A    0.1,=0A    0.11,=0A    0.11,=0A    0.11=0A  ],=0A  "perf-profile.cpu=
-cycles.__call_rcu.call_rcu_sched.dentry_free.__dentry_kill.dput": [=0A    =
0.11,=0A    0.11,=0A    0.11,=0A    0.12,=0A    0.12=0A  ],=0A  "perf-profi=
le.cpu-cycles.avc_has_perm.inode_has_perm.selinux_file_open.security_file_o=
pen.do_dentry_open": [=0A    0.11,=0A    0.11,=0A    0.12,=0A    0.1,=0A   =
 0.11=0A  ],=0A  "perf-profile.cpu-cycles.__rmqueue.get_page_from_freelist.=
__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc": [=0A    0.1=
1,=0A    0.12,=0A    0.11,=0A    0.13,=0A    0.11=0A  ],=0A  "perf-profile.=
cpu-cycles.cmpxchg_double_slab.isra.51.__slab_free.kmem_cache_free.file_fre=
e_rcu.rcu_nocb_kthread": [=0A    0.11,=0A    0.11,=0A    0.13,=0A    0.13,=
=0A    0.13=0A  ],=0A  "perf-profile.cpu-cycles.__mnt_want_write.mnt_want_w=
rite.do_last.path_openat.do_filp_open": [=0A    0.11,=0A    0.12,=0A    0.1=
1,=0A    0.11,=0A    0.12=0A  ],=0A  "perf-profile.cpu-cycles.path_init.pat=
h_openat.do_filp_open.do_sys_open.sys_openat": [=0A    0.11,=0A    0.13,=0A=
    0.11,=0A    0.12,=0A    0.14=0A  ],=0A  "perf-profile.cpu-cycles.selinu=
x_file_permission.security_file_permission.iterate_dir.sys_getdents.system_=
call_fastpath": [=0A    0.11,=0A    0.11,=0A    0.1,=0A    0.12,=0A    0.11=
=0A  ],=0A  "perf-profile.cpu-cycles.__delete_from_page_cache.delete_from_p=
age_cache.truncate_inode_page.truncate_inode_pages_range.truncate_inode_pag=
es_final": [=0A    0.11,=0A    0.11,=0A    0.11,=0A    0.11,=0A    0.11=0A =
 ],=0A  "perf-profile.cpu-cycles.release_pages.__pagevec_release.truncate_i=
node_pages_range.truncate_inode_pages_final.evict": [=0A    0.11,=0A    0.1=
,=0A    0.1,=0A    0.1,=0A    0.11=0A  ],=0A  "perf-profile.cpu-cycles.__d_=
lookup_rcu.lookup_fast.do_last.path_openat.do_filp_open": [=0A    0.11,=0A =
   0.09,=0A    0.1,=0A    0.1,=0A    0.1=0A  ],=0A  "perf-profile.cpu-cycle=
s.selinux_file_open.security_file_open.do_dentry_open.finish_open.do_last":=
 [=0A    0.1,=0A    0.11,=0A    0.1,=0A    0.1,=0A    0.1=0A  ],=0A  "perf-=
profile.cpu-cycles.do_notify_resume.int_signal.close": [=0A    0.1,=0A    0=
=2E1,=0A    0.11,=0A    0.11,=0A    0.11=0A  ],=0A  "perf-profile.cpu-cycle=
s.__might_sleep.generic_file_read_iter.new_sync_read.vfs_read.sys_pread64":=
 [=0A    0.1,=0A    0.1,=0A    0.09,=0A    0.1,=0A    0.1=0A  ],=0A  "perf-=
profile.cpu-cycles.security_inode_permission.inode_permission.link_path_wal=
k.path_lookupat.filename_lookup": [=0A    0.1,=0A    0.1,=0A    0.12,=0A   =
 0.09,=0A    0.11=0A  ],=0A  "perf-profile.cpu-cycles.__add_to_page_cache_l=
ocked.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin.=
simple_write_begin": [=0A    0.1,=0A    0.11,=0A    0.1,=0A    0.11,=0A    =
0.1=0A  ],=0A  "perf-profile.cpu-cycles.sys_getdents.system_call_fastpath":=
 [=0A    0.1,=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.09=0A  ],=0A  "pe=
rf-profile.cpu-cycles.lookup_fast.path_lookupat.filename_lookup.user_path_a=
t_empty.user_path_at": [=0A    0.1,=0A    0.1,=0A    0.1,=0A    0.1,=0A    =
0.11=0A  ],=0A  "perf-profile.cpu-cycles.lockref_get_not_dead.complete_walk=
=2Epath_lookupat.filename_lookup.user_path_at_empty": [=0A    0.1,=0A    0.=
09,=0A    0.09,=0A    0.09,=0A    0.1=0A  ],=0A  "perf-profile.cpu-cycles._=
_alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_=
page.grab_cache_page_write_begin": [=0A    0.1,=0A    0.1,=0A    0.1,=0A   =
 0.1,=0A    0.1=0A  ],=0A  "perf-profile.cpu-cycles.iov_iter_fault_in_reada=
ble.generic_perform_write.__generic_file_write_iter.generic_file_write_iter=
=2Enew_sync_write": [=0A    0.09,=0A    0.1,=0A    0.1,=0A    0.1,=0A    0.=
1=0A  ],=0A  "perf-profile.cpu-cycles.free_hot_cold_page.free_hot_cold_page=
_list.release_pages.__pagevec_release.truncate_inode_pages_range": [=0A    =
0.09,=0A    0.09,=0A    0.08,=0A    0.08,=0A    0.09=0A  ],=0A  "perf-profi=
le.cpu-cycles.drop_nlink.simple_unlink.vfs_unlink.do_unlinkat.sys_unlink": =
[=0A    0.09,=0A    0.09,=0A    0.1,=0A    0.09,=0A    0.09=0A  ],=0A  "per=
f-profile.cpu-cycles.__radix_tree_create.__add_to_page_cache_locked.add_to_=
page_cache_lru.pagecache_get_page.grab_cache_page_write_begin": [=0A    0.0=
9,=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.09=0A  ],=0A  "perf-profile.=
cpu-cycles.cp_new_stat.SYSC_newstat.sys_newstat.system_call_fastpath.__xsta=
t64": [=0A    0.09,=0A    0.1,=0A    0.09,=0A    0.09,=0A    0.09=0A  ],=0A=
  "perf-profile.cpu-cycles.vfs_read.sys_pread64.system_call_fastpath.pread6=
4": [=0A    0.09,=0A    0.1,=0A    0.1,=0A    0.09,=0A    0.1=0A  ],=0A  "p=
erf-profile.cpu-cycles.file_ra_state_init.finish_open.do_last.path_openat.d=
o_filp_open": [=0A    0.09,=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08=
=0A  ],=0A  "perf-profile.cpu-cycles.__strdup": [=0A    0.09,=0A    0.08,=
=0A    0.08,=0A    0.08,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.tru=
ncate_inode_pages_range.truncate_inode_pages_final.evict.iput.do_unlinkat":=
 [=0A    0.09,=0A    0.09,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "p=
erf-profile.cpu-cycles.__pagevec_lru_add_fn.pagevec_lru_move_fn.__lru_cache=
_add.lru_cache_add.add_to_page_cache_lru": [=0A    0.09,=0A    0.08,=0A    =
0.09,=0A    0.08,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.fput.filp_=
close.__close_fd.sys_close.system_call_fastpath": [=0A    0.09,=0A    0.09,=
=0A    0.07,=0A    0.08,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.sel=
inux_inode_permission.__inode_permission.inode_permission.link_path_walk.pa=
th_lookupat": [=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.09,=0A    0.09=
=0A  ],=0A  "perf-profile.cpu-cycles.__alloc_fd.get_unused_fd_flags.do_sys_=
open.sys_openat.system_call_fastpath": [=0A    0.09,=0A    0.09,=0A    0.08=
,=0A    0.08,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.__generic_file=
_write_iter.generic_file_write_iter.new_sync_write.vfs_write.sys_pwrite64":=
 [=0A    0.08,=0A    0.09,=0A    0.09,=0A    0.08,=0A    0.07=0A  ],=0A  "p=
erf-profile.cpu-cycles.kmem_cache_free.final_putname.putname.do_sys_open.sy=
s_open": [=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ]=
,=0A  "perf-profile.cpu-cycles.mutex_unlock.sys_getdents.system_call_fastpa=
th": [=0A    0.08,=0A    0.09,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A=
  "perf-profile.cpu-cycles.may_open.do_last.path_openat.do_filp_open.do_sys=
_open": [=0A    0.08,=0A    0.11,=0A    0.09,=0A    0.09,=0A    0.09=0A  ],=
=0A  "perf-profile.cpu-cycles.selinux_file_permission.security_file_permiss=
ion.rw_verify_area.vfs_read.sys_pread64": [=0A    0.08,=0A    0.09,=0A    0=
=2E08,=0A    0.08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.mutex_loc=
k_killable.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.08,=0A=
    0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-c=
ycles._copy_to_user.dcache_readdir.iterate_dir.sys_getdents.system_call_fas=
tpath": [=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.09,=0A    0.08=0A  ],=
=0A  "perf-profile.cpu-cycles.ramfs_get_inode.ramfs_mknod.ramfs_create.vfs_=
create.do_last": [=0A    0.08,=0A    0.09,=0A    0.09,=0A    0.08,=0A    0.=
08=0A  ],=0A  "perf-profile.cpu-cycles.simple_write_end.__generic_file_writ=
e_iter.generic_file_write_iter.new_sync_write.vfs_write": [=0A    0.08,=0A =
   0.09,=0A    0.1,=0A    0.1,=0A    0.1=0A  ],=0A  "perf-profile.cpu-cycle=
s.kmem_cache_alloc.getname_flags.getname.do_sys_open.sys_openat": [=0A    0=
=2E08,=0A    0.08,=0A    0.09,=0A    0.08,=0A    0.09=0A  ],=0A  "perf-prof=
ile.cpu-cycles._raw_spin_unlock.iterate_dir.sys_getdents.system_call_fastpa=
th": [=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A=
  "perf-profile.cpu-cycles.open64": [=0A    0.08,=0A    0.09,=0A    0.08,=
=0A    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.__libc_calloc":=
 [=0A    0.08,=0A    0.07,=0A    0.08,=0A    0.07,=0A    0.07=0A  ],=0A  "p=
erf-profile.cpu-cycles.snprintf": [=0A    0.08,=0A    0.08,=0A    0.12,=0A =
   0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.fgets@plt": [=0A   =
 0.08,=0A    0.12,=0A    0.04,=0A    0.05,=0A    0.06=0A  ],=0A  "perf-prof=
ile.cpu-cycles.alloc_pages_current.__page_cache_alloc.pagecache_get_page.gr=
ab_cache_page_write_begin.simple_write_begin": [=0A    0.08,=0A    0.08,=0A=
    0.09,=0A    0.09,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.fsnoti=
fy.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.08,=0A    0.08=
,=0A    0.08,=0A    0.09,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cycles.fi=
nd_pid_ns.SYSC_kill.sys_kill.system_call_fastpath.kill": [=0A    0.08,=0A  =
  0.08,=0A    0.08,=0A    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cyc=
les.new_slab.__slab_alloc.kmem_cache_alloc.get_empty_filp.path_openat": [=
=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "per=
f-profile.cpu-cycles.path_init.path_openat.do_filp_open.do_sys_open.sys_ope=
n": [=0A    0.08,=0A    0.09,=0A    0.07,=0A    0.08,=0A    0.09=0A  ],=0A =
 "perf-profile.cpu-cycles.update_cfs_shares.task_tick_fair.scheduler_tick.u=
pdate_process_times.tick_sched_handle": [=0A    0.08,=0A    0.06,=0A    0.0=
6,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.sys_kill.kill=
": [=0A    0.07,=0A    0.08,=0A    0.08,=0A    0.07,=0A    0.07=0A  ],=0A  =
"perf-profile.cpu-cycles.selinux_inode_permission.security_inode_permission=
=2E__inode_permission.inode_permission.may_open": [=0A    0.07,=0A    0.07,=
=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.__d=
_drop.dput.terminate_walk.path_lookupat.filename_lookup": [=0A    0.07,=0A =
   0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A  "perf-profile.cpu-cy=
cles.process_measurement.ima_file_check.do_last.path_openat.do_filp_open": =
[=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "pe=
rf-profile.cpu-cycles.radix_tree_next_chunk.find_get_entries.pagevec_lookup=
_entries.truncate_inode_pages_range.truncate_inode_pages_final": [=0A    0.=
07,=0A    0.08,=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.memcpy.d_alloc.dcache_dir_open.do_dentry_open.finish_open": [=
=0A    0.07,=0A    0.08,=0A    0.08,=0A    0.09,=0A    0.09=0A  ],=0A  "per=
f-profile.cpu-cycles.path_openat.do_filp_open.do_sys_open.sys_openat.system=
_call_fastpath": [=0A    0.07,=0A    0.08,=0A    0.07,=0A    0.08,=0A    0.=
07=0A  ],=0A  "perf-profile.cpu-cycles.lockref_put_or_lock.dput.terminate_w=
alk.do_last.path_openat": [=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07,=
=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.kmem_cache_al=
loc.selinux_inode_alloc_security.security_inode_alloc.inode_init_always": [=
=0A    0.07,=0A    0.08,=0A    0.09,=0A    0.08,=0A    0.08=0A  ],=0A  "per=
f-profile.cpu-cycles.dnotify_flush.filp_close.__close_fd.sys_close.system_c=
all_fastpath": [=0A    0.07,=0A    0.07,=0A    0.06,=0A    0.07,=0A    0.07=
=0A  ],=0A  "perf-profile.cpu-cycles.pread64": [=0A    0.07,=0A    0.07,=0A=
    0.09,=0A    0.07,=0A    0.09=0A  ],=0A  "perf-profile.cpu-cycles.closed=
ir": [=0A    0.07,=0A    0.05,=0A    0.05,=0A    0.06,=0A    0.05=0A  ],=0A=
  "perf-profile.cpu-cycles.__list_del_entry.selinux_inode_free_security.sec=
urity_inode_free.__destroy_inode.destroy_inode": [=0A    0.07,=0A    0.07,=
=0A    0.08,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.kil=
l_pid_info.SYSC_kill.sys_kill.system_call_fastpath.kill": [=0A    0.07,=0A =
   0.07,=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cy=
cles.__d_rehash._d_rehash.d_rehash.simple_lookup.lookup_real": [=0A    0.07=
,=0A    0.07,=0A    0.08,=0A    0.07,=0A    0.08=0A  ],=0A  "perf-profile.c=
pu-cycles._raw_spin_lock_irqsave.get_page_from_freelist.__alloc_pages_nodem=
ask.alloc_pages_current.new_slab": [=0A    0.07,=0A    0.06,=0A    0.07,=0A=
    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.__mutex_init.alloc=
_inode.new_inode_pseudo.new_inode.ramfs_get_inode": [=0A    0.07,=0A    0.0=
6,=0A    0.07,=0A    0.06,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.u=
nlock_page.simple_write_end.generic_perform_write.__generic_file_write_iter=
=2Egeneric_file_write_iter": [=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.=
06,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.fsnotify.security_file_p=
ermission.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.07,=0A =
   0.07,=0A    0.07,=0A    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cy=
cles.filp_close.__close_fd.sys_close.system_call_fastpath.close": [=0A    0=
=2E07,=0A    0.07,=0A    0.07,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-prof=
ile.cpu-cycles.locks_remove_file.__fput.____fput.task_work_run.do_notify_re=
sume": [=0A    0.07,=0A    0.07,=0A    0.05,=0A    0.06,=0A    0.06=0A  ],=
=0A  "perf-profile.cpu-cycles.__might_sleep.generic_perform_write.__generic=
_file_write_iter.generic_file_write_iter.new_sync_write": [=0A    0.07,=0A =
   0.08,=0A    0.07,=0A    0.08,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cy=
cles.__percpu_counter_add.get_empty_filp.path_openat.do_filp_open.do_sys_op=
en": [=0A    0.07,=0A    0.08,=0A    0.08,=0A    0.08,=0A    0.08=0A  ],=0A=
  "perf-profile.cpu-cycles.d_lookup.lookup_dcache.__lookup_hash.lookup_slow=
=2Epath_lookupat": [=0A    0.07,=0A    0.07,=0A    0.07,=0A    0.07,=0A    =
0.07=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_open.do_dentry_open.f=
inish_open.do_last.path_openat": [=0A    0.07,=0A    0.08,=0A    0.06,=0A  =
  0.06,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.generic_fillattr.sim=
ple_getattr.vfs_getattr_nosec.vfs_getattr.vfs_fstat": [=0A    0.07,=0A    0=
=2E08,=0A    0.08,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycl=
es.ima_file_check.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.=
07,=0A    0.06,=0A    0.07,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.get_mem_cgroup_from_mm.mem_cgroup_try_charge_mm.mem_cgroup_ch=
arge_file.__add_to_page_cache_locked.add_to_page_cache_lru": [=0A    0.07,=
=0A    0.06,=0A    0.07,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cp=
u-cycles.__dentry_kill.dput.dcache_dir_close.__fput.____fput": [=0A    0.07=
,=0A    0.07,=0A    0.06,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.c=
pu-cycles.link_path_walk.path_lookupat.filename_lookup.user_path_parent.do_=
unlinkat": [=0A    0.06,=0A    0.07,=0A    0.06,=0A    0.07,=0A    0.07=0A =
 ],=0A  "perf-profile.cpu-cycles.memset.selinux_file_alloc_security.securit=
y_file_alloc.get_empty_filp.path_openat": [=0A    0.06,=0A    0.06,=0A    0=
=2E06,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.put_page.=
simple_write_end.generic_perform_write.__generic_file_write_iter.generic_fi=
le_write_iter": [=0A    0.06,=0A    0.07,=0A    0.06,=0A    0.07,=0A    0.0=
7=0A  ],=0A  "perf-profile.cpu-cycles.lockref_get.path_get.do_dentry_open.f=
inish_open.do_last": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=0A  =
  0.05=0A  ],=0A  "perf-profile.cpu-cycles.inode_permission.path_openat.do_=
filp_open.do_sys_open.sys_openat": [=0A    0.06,=0A    0.05,=0A    0.07,=0A=
    0.07,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.lockref_put_or_loc=
k.dput.__fput.____fput.task_work_run": [=0A    0.06,=0A    0.06,=0A    0.07=
,=0A    0.07,=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_lock=
_irqsave.release_pages.__pagevec_release.truncate_inode_pages_range.truncat=
e_inode_pages_final": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=0A =
   0.06=0A  ],=0A  "perf-profile.cpu-cycles.__close_fd.sys_close.system_cal=
l_fastpath.close": [=0A    0.06,=0A    0.05,=0A    0.07,=0A    0.06,=0A    =
0.05=0A  ],=0A  "perf-profile.cpu-cycles.copy_from_user_atomic_iovec.iov_it=
er_copy_from_user_atomic.generic_perform_write.__generic_file_write_iter.ge=
neric_file_write_iter": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.07,=
=0A    0.07=0A  ],=0A  "perf-profile.cpu-cycles.__slab_alloc.kmem_cache_all=
oc.get_empty_filp.path_openat.do_filp_open": [=0A    0.06,=0A    0.06,=0A  =
  0.06,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.kmem_cac=
he_alloc.getname_flags.getname.do_sys_open.sys_open": [=0A    0.06,=0A    0=
=2E06,=0A    0.07,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycl=
es.fsnotify.__fput.____fput.task_work_run.do_notify_resume": [=0A    0.06,=
=0A    0.06,=0A    0.06,=0A    0.07,=0A    0.06=0A  ],=0A  "perf-profile.cp=
u-cycles.pagecache_get_page.generic_file_read_iter.new_sync_read.vfs_read.s=
ys_pread64": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06=
=0A  ],=0A  "perf-profile.cpu-cycles.strlen@plt": [=0A    0.06,=0A    0.06,=
=0A    0.06,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.__f=
xstat64": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06=0A  =
],=0A  "perf-profile.cpu-cycles.security_inode_getattr.vfs_fstatat.SYSC_new=
stat.sys_newstat.system_call_fastpath": [=0A    0.06,=0A    0.06,=0A    0.0=
6,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.cp_new_stat.S=
YSC_newfstat.sys_newfstat.system_call_fastpath.__fxstat64": [=0A    0.06,=
=0A    0.06,=0A    0.05,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cp=
u-cycles.__list_del_entry.list_del.free_pcppages_bulk.free_hot_cold_page.fr=
ee_hot_cold_page_list": [=0A    0.06,=0A    0.06,=0A    0.05,=0A    0.06,=
=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.bit_waitqueue.__inode_wait_=
for_writeback.inode_wait_for_writeback.evict.iput": [=0A    0.06,=0A    0.0=
6,=0A    0.06,=0A    0.05,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.m=
utex_lock.lookup_slow.path_lookupat.filename_lookup.user_path_at_empty": [=
=0A    0.06,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.06=0A  ],=0A  "per=
f-profile.cpu-cycles.legitimize_mnt.path_lookupat.filename_lookup.user_path=
_at_empty.user_path_at": [=0A    0.06,=0A    0.05,=0A    0.04,=0A    0.06,=
=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.filename_lookup.user_path_a=
t_empty.user_path_at.vfs_fstatat.SYSC_newstat": [=0A    0.06,=0A    0.06,=
=0A    0.07,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.cop=
y_from_user_atomic_iovec.generic_perform_write.__generic_file_write_iter.ge=
neric_file_write_iter.new_sync_write": [=0A    0.06,=0A    0.06,=0A    0.06=
,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.lockref_put_or=
_lock.dput.dcache_dir_close.__fput.____fput": [=0A    0.06,=0A    0.06,=0A =
   0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.pagevec=
_lru_move_fn.__lru_cache_add.lru_cache_add.add_to_page_cache_lru.pagecache_=
get_page": [=0A    0.06,=0A    0.05,=0A    0.06,=0A    0.05,=0A    0.06=0A =
 ],=0A  "perf-profile.cpu-cycles.strncpy_from_user.getname_flags.getname.do=
_sys_open.sys_openat": [=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.06,=0A=
    0.06=0A  ],=0A  "perf-profile.cpu-cycles.__wake_up_bit.unlock_page.trun=
cate_inode_pages_range.truncate_inode_pages_final.evict": [=0A    0.06,=0A =
   0.06,=0A    0.05,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cy=
cles.mem_cgroup_try_charge.mem_cgroup_try_charge_mm.mem_cgroup_charge_file.=
__add_to_page_cache_locked.add_to_page_cache_lru": [=0A    0.06,=0A    0.06=
,=0A    0.05,=0A    0.05,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.__=
list_del_entry.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.06=
,=0A    0.05,=0A    0.06,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-profile.c=
pu-cycles.__fget_light.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=
=0A    0.06,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.04=0A  ],=0A  "per=
f-profile.cpu-cycles.get_unused_fd_flags.sys_openat.system_call_fastpath": =
[=0A    0.06,=0A    0.06,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "pe=
rf-profile.cpu-cycles.lockref_get_not_dead.complete_walk.do_last.path_opena=
t.do_filp_open": [=0A    0.05,=0A    0.05,=0A    0.06,=0A    0.05,=0A    0.=
06=0A  ],=0A  "perf-profile.cpu-cycles.lookup_fast.do_last.path_openat.do_f=
ilp_open.do_sys_open": [=0A    0.05,=0A    0.06,=0A    0.06,=0A    0.06,=0A=
    0.06=0A  ],=0A  "perf-profile.cpu-cycles.__alloc_fd.get_unused_fd_flags=
=2Edo_sys_open.sys_open.system_call_fastpath": [=0A    0.05,=0A    0.05,=0A=
    0.05,=0A    0.05,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.legiti=
mize_mnt.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.05,=0A   =
 0.05,=0A    0.04,=0A    0.07,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycl=
es.__list_del_entry.dcache_readdir.iterate_dir.sys_getdents.system_call_fas=
tpath": [=0A    0.05,=0A    0.05,=0A    0.06,=0A    0.06,=0A    0.05=0A  ],=
=0A  "perf-profile.cpu-cycles.groups_search.in_group_p.generic_permission._=
_inode_permission.inode_permission": [=0A    0.05,=0A    0.04,=0A    0.05,=
=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.fsnotify.securi=
ty_file_permission.rw_verify_area.vfs_read.sys_pread64": [=0A    0.05,=0A  =
  0.04,=0A    0.04,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cyc=
les.ima_file_free.__fput.____fput.task_work_run.do_notify_resume": [=0A    =
0.05,=0A    0.05,=0A    0.05,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-profi=
le.cpu-cycles.vfs_fstatat.SYSC_newstat.sys_newstat.system_call_fastpath.__x=
stat64": [=0A    0.05,=0A    0.05,=0A    0.06,=0A    0.05,=0A    0.06=0A  ]=
,=0A  "perf-profile.cpu-cycles.new_sync_read.vfs_read.sys_pread64.system_ca=
ll_fastpath.pread64": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.06,=0A =
   0.05=0A  ],=0A  "perf-profile.cpu-cycles.__radix_tree_lookup.find_get_en=
try.pagecache_get_page.generic_file_read_iter.new_sync_read": [=0A    0.05,=
=0A    0.05,=0A    0.05,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cp=
u-cycles.__call_rcu_nocb_enqueue.__call_rcu.call_rcu_sched.selinux_inode_fr=
ee_security.security_inode_free": [=0A    0.05,=0A    0.05,=0A    0.05,=0A =
   0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.security_file_permi=
ssion.iterate_dir.sys_getdents.system_call_fastpath": [=0A    0.05,=0A    0=
=2E05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycl=
es.security_inode_permission.inode_permission.link_path_walk.path_openat.do=
_filp_open": [=0A    0.05,=0A    0.06,=0A    0.06,=0A    0.05,=0A    0.07=
=0A  ],=0A  "perf-profile.cpu-cycles.in_group_p.__inode_permission.inode_pe=
rmission.link_path_walk.path_lookupat": [=0A    0.05,=0A    0.05,=0A    0.0=
6,=0A    0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode=
_free_security.security_inode_free.__destroy_inode.destroy_inode.evict": [=
=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.06=0A  ],=0A  "per=
f-profile.cpu-cycles._raw_spin_lock_irq.__add_to_page_cache_locked.add_to_p=
age_cache_lru.pagecache_get_page.grab_cache_page_write_begin": [=0A    0.05=
,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.c=
pu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.v=
fs_write.sys_pwrite64": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=
=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.sys_close.close": [=0A    0=
=2E05,=0A    0.06,=0A    0.06,=0A    0.06,=0A    0.05=0A  ],=0A  "perf-prof=
ile.cpu-cycles.selinux_inode_permission.__inode_permission.inode_permission=
=2Elink_path_walk.path_openat": [=0A    0.05,=0A    0.06,=0A    0.06,=0A   =
 0.05,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.__lru_cache_add.lru_c=
ache_add.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_beg=
in": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A=
  "perf-profile.cpu-cycles.simple_write_begin.generic_perform_write.__gener=
ic_file_write_iter.generic_file_write_iter.new_sync_write": [=0A    0.05,=
=0A    0.04,=0A    0.04,=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profile.cp=
u-cycles.user_path_at_empty.user_path_at.vfs_fstatat.SYSC_newstat.sys_newst=
at": [=0A    0.05,=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.06=0A  ],=0A=
  "perf-profile.cpu-cycles.__list_add.d_alloc.lookup_dcache.__lookup_hash.l=
ookup_slow": [=0A    0.05,=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.04=
=0A  ],=0A  "perf-profile.cpu-cycles.locks_remove_posix.__close_fd.sys_clos=
e.system_call_fastpath.close": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    =
0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.__ctype_b_loc@plt": [=
=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "per=
f-profile.cpu-cycles._IO_getline": [=0A    0.05,=0A    0.04,=0A    0.05,=0A=
    0.04,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.ihold.sys_unlink.s=
ystem_call_fastpath.unlink": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.=
05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.path_openat.do_filp_open=
=2Edo_sys_open.sys_open.system_call_fastpath": [=0A    0.05,=0A    0.05,=0A=
    0.05,=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.mem_cg=
roup_page_lruvec.pagevec_lru_move_fn.__lru_cache_add.lru_cache_add.add_to_p=
age_cache_lru": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.0=
5=0A  ],=0A  "perf-profile.cpu-cycles.__inode_permission.link_path_walk.pat=
h_lookupat.filename_lookup.user_path_at_empty": [=0A    0.05,=0A    0.05,=
=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__m=
nt_want_write.mnt_want_write.do_unlinkat.sys_unlink.system_call_fastpath": =
[=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "pe=
rf-profile.cpu-cycles._raw_spin_lock.free_one_page.__free_pages_ok.__free_p=
ages.__free_slab": [=0A    0.05,=0A    0.3,=0A    0.24,=0A    0.33,=0A    0=
=2E14=0A  ],=0A  "perf-profile.cpu-cycles.__list_add.inode_doinit_with_dent=
ry.selinux_d_instantiate.security_d_instantiate.d_instantiate": [=0A    0.0=
5,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.=
cpu-cycles.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=0A=
    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-p=
rofile.cpu-cycles.inode_permission.path_openat.do_filp_open.do_sys_open.sys=
_open": [=0A    0.05,=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=
=0A  "perf-profile.cpu-cycles.add_to_page_cache_lru.pagecache_get_page.grab=
_cache_page_write_begin.simple_write_begin.generic_perform_write": [=0A    =
0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profi=
le.cpu-cycles.generic_permission.inode_permission.link_path_walk.path_looku=
pat.filename_lookup": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A =
   0.04=0A  ],=0A  "perf-profile.cpu-cycles.strncpy_from_user.getname_flags=
=2Egetname.do_sys_open.sys_open": [=0A    0.05,=0A    0.05,=0A    0.05,=0A =
   0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__slab_alloc.kmem_c=
ache_alloc.__d_alloc.d_alloc.dcache_dir_open": [=0A    0.05,=0A    0.05,=0A=
    0.05,=0A    0.04,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__fget=
_light.vfs_fstat.SYSC_newfstat.sys_newfstat.system_call_fastpath": [=0A    =
0.05,=0A    0.04,=0A    0.04,=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profi=
le.cpu-cycles.lockref_put_or_lock.dput.path_put.vfs_fstatat.SYSC_newstat": =
[=0A    0.05,=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=0A  "pe=
rf-profile.cpu-cycles.copy_page_to_iter.generic_file_read_iter.new_sync_rea=
d.vfs_read.sys_pread64": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=
=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.getname_flags.getname.do_sy=
s_open.sys_openat.system_call_fastpath": [=0A    0.05,=0A    0.05,=0A    0.=
05,=0A    0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.__srcu_read_=
lock.fsnotify.vfs_write.sys_pwrite64.system_call_fastpath": [=0A    0.05,=
=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cp=
u-cycles.sys_newstat.__xstat64": [=0A    0.05,=0A    0.06,=0A    0.05,=0A  =
  0.06,=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.dput.do_last.path_op=
enat.do_filp_open.do_sys_open": [=0A    0.05,=0A    0.04,=0A    0.04,=0A   =
 0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.fsnotify_find_inode_m=
ark.dnotify_flush.filp_close.__close_fd.sys_close": [=0A    0.05,=0A    0.0=
5,=0A    0.05,=0A    0.04,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.p=
age_waitqueue.truncate_inode_pages_range.truncate_inode_pages_final.evict.i=
put": [=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05,=0A    0.05=0A  ],=
=0A  "perf-profile.cpu-cycles.fsnotify.vfs_read.sys_pread64.system_call_fas=
tpath.pread64": [=0A    0.05,=0A    0.05,=0A    0.04,=0A    0.04,=0A    0.0=
5=0A  ],=0A  "perf-profile.cpu-cycles.iov_iter_copy_from_user_atomic.generi=
c_perform_write.__generic_file_write_iter.generic_file_write_iter.new_sync_=
write": [=0A    0.05,=0A    0.04,=0A    0.05,=0A    0.04,=0A    0.05=0A  ],=
=0A  "perf-profile.cpu-cycles.security_file_open.do_dentry_open.finish_open=
=2Edo_last.path_openat": [=0A    0.05,=0A    0.04,=0A    0.05,=0A    0.06,=
=0A    0.06=0A  ],=0A  "perf-profile.cpu-cycles.generic_file_write_iter.new=
_sync_write.vfs_write.sys_pwrite64.system_call_fastpath": [=0A    0.05,=0A =
   0.05,=0A    0.05,=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cy=
cles.kmem_cache_alloc.__d_alloc.d_alloc.lookup_dcache.do_last": [=0A    0.0=
4,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.=
cpu-cycles.sysret_check.kill": [=0A    0.04,=0A    0.05,=0A    0.05,=0A    =
0.05,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.free_pages_prepare.fre=
e_hot_cold_page.free_hot_cold_page_list.release_pages.__pagevec_release": [=
=0A    0.04,=0A    0.04,=0A    0.05,=0A    0.04,=0A    0.04=0A  ],=0A  "per=
f-profile.cpu-cycles.may_create.isra.38.selinux_inode_create.security_inode=
_create.vfs_create.do_last": [=0A    0.04,=0A    0.05,=0A    0.04,=0A    0.=
05,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.next_zones_zonelist.__al=
loc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_pag=
e": [=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.04,=0A    0.05=0A  ],=0A =
 "perf-profile.cpu-cycles.in_group_p.__inode_permission.inode_permission.li=
nk_path_walk.path_openat": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.05=
,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.fsnotify.vfs_write.sys_pwr=
ite64.system_call_fastpath.__libc_pwrite": [=0A    0.04,=0A    0.04,=0A    =
0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.filldir.it=
erate_dir.sys_getdents.system_call_fastpath": [=0A    0.04,=0A    0.04,=0A =
   0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.mntget.=
do_dentry_open.finish_open.do_last.path_openat": [=0A    0.04,=0A    0.04,=
=0A    0.04,=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.SYS=
C_kill.system_call_fastpath.kill": [=0A    0.04,=0A    0.04,=0A    0.04,=0A=
    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.rw_verify_area.vfs=
_read.sys_pread64.system_call_fastpath.pread64": [=0A    0.04,=0A    0.04,=
=0A    0.04,=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.fpu=
t.__close_fd.sys_close.system_call_fastpath.close": [=0A    0.04,=0A    0.0=
4,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.g=
et_unused_fd_flags.do_sys_open.sys_openat.system_call_fastpath": [=0A    0.=
04,=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.04=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.__percpu_counter_add.__fput.____fput.task_work_run.do_notify_=
resume": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.05,=0A    0.05=0A  ]=
,=0A  "perf-profile.cpu-cycles.find_vpid.sys_kill.system_call_fastpath.kill=
": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A  =
"perf-profile.cpu-cycles.selinux_file_permission.iterate_dir.sys_getdents.s=
ystem_call_fastpath": [=0A    0.04,=0A    0.05,=0A    0.05,=0A    0.05,=0A =
   0.05=0A  ],=0A  "perf-profile.cpu-cycles.__set_page_dirty_no_writeback.s=
imple_write_end.generic_perform_write.__generic_file_write_iter.generic_fil=
e_write_iter": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=
=0A  ],=0A  "perf-profile.cpu-cycles.__inode_permission.link_path_walk.path=
_openat.do_filp_open.do_sys_open": [=0A    0.04,=0A    0.04,=0A    0.04,=0A=
    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.__list_add.iterate=
_dir.sys_getdents.system_call_fastpath": [=0A    0.04,=0A    0.04,=0A    0.=
04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.__libc_pwrit=
e": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.03=0A  ],=0A =
 "perf-profile.cpu-cycles.sys_openat": [=0A    0.04,=0A    0.03,=0A    0.03=
,=0A    0.03,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.int_with_check=
=2Eclose": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A =
 ],=0A  "perf-profile.cpu-cycles.__put_user_8.system_call_fastpath": [=0A  =
  0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-pro=
file.cpu-cycles.strstr@plt": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.=
04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.unlazy_walk.lookup_fast.=
path_lookupat.filename_lookup.user_path_at_empty": [=0A    0.04,=0A    0.04=
,=0A    0.03,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.fi=
le_ra_state_init.do_dentry_open.finish_open.do_last.path_openat": [=0A    0=
=2E04,=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__dentry_kill.dput.terminate_walk.path_lookupat.filename_loo=
kup": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=
=0A  "perf-profile.cpu-cycles.simple_lookup.__lookup_hash.lookup_slow.path_=
lookupat.filename_lookup": [=0A    0.04,=0A    0.05,=0A    0.04,=0A    0.05=
,=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.memcpy.d_alloc.lookup_dcac=
he.__lookup_hash.lookup_slow": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    =
0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.ima_match_policy.ima_g=
et_action.process_measurement.ima_file_check.do_last": [=0A    0.04,=0A    =
0.04,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycle=
s.__radix_tree_preload.radix_tree_maybe_preload.__add_to_page_cache_locked.=
add_to_page_cache_lru.pagecache_get_page": [=0A    0.04,=0A    0.04,=0A    =
0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.get_unused=
_fd_flags.sys_open.system_call_fastpath.open64": [=0A    0.04,=0A    0.04,=
=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__f=
dget.system_call_fastpath": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.0=
4,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__fsnotify_parent.__fput.=
____fput.task_work_run.do_notify_resume": [=0A    0.04,=0A    0.04,=0A    0=
=2E04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.__sb_star=
t_write.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=0A   =
 0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__inc_zone_state.zone_statistics.get_page_from_freelist.__al=
loc_pages_nodemask.alloc_pages_current": [=0A    0.04,=0A    0.04,=0A    0.=
04,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.current_kern=
el_time.current_fs_time.touch_atime.iterate_dir.sys_getdents": [=0A    0.04=
,=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.05=0A  ],=0A  "perf-profile.c=
pu-cycles.inode_has_perm.isra.32.selinux_inode_getattr.security_inode_getat=
tr.vfs_getattr.vfs_fstat": [=0A    0.04,=0A    0.03,=0A    0.03,=0A    0.04=
,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_lock_irqsave.pag=
evec_lru_move_fn.__lru_cache_add.lru_cache_add.add_to_page_cache_lru": [=0A=
    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-p=
rofile.cpu-cycles.cancel_dirty_page.truncate_inode_page.truncate_inode_page=
s_range.truncate_inode_pages_final.evict": [=0A    0.04,=0A    0.04,=0A    =
0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.ima_get_ac=
tion.ima_file_check.do_last.path_openat.do_filp_open": [=0A    0.04,=0A    =
0.03,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycle=
s.truncate_inode_page.truncate_inode_pages_range.truncate_inode_pages_final=
=2Eevict.iput": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.0=
4=0A  ],=0A  "perf-profile.cpu-cycles.delete_from_page_cache.truncate_inode=
_page.truncate_inode_pages_range.truncate_inode_pages_final.evict": [=0A   =
 0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.05=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__radix_tree_lookup.find_get_entry.pagecache_get_page.grab_c=
ache_page_write_begin.simple_write_begin": [=0A    0.04,=0A    0.04,=0A    =
0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.legitimize=
_mnt.lookup_fast.path_lookupat.filename_lookup.user_path_at_empty": [=0A   =
 0.04,=0A    0.03,=0A    0.04,=0A    0.05,=0A    0.03=0A  ],=0A  "perf-prof=
ile.cpu-cycles.dcache_readdir.sys_getdents.system_call_fastpath": [=0A    0=
=2E04,=0A    0,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.filename_loo=
kup.user_path_at.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A    0.04,=0A   =
 0.03,=0A    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycl=
es.vfs_fstatat.sys_newstat.system_call_fastpath.__xstat64": [=0A    0.04,=
=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.fsnotify.do_sys_open.sys_openat.system_call_fastpath": [=0A    0.0=
4,=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.=
cpu-cycles.check_kill_permission.kill_pid_info.SYSC_kill.sys_kill.system_ca=
ll_fastpath": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.04=
=0A  ],=0A  "perf-profile.cpu-cycles.__fsnotify_parent.iterate_dir.sys_getd=
ents.system_call_fastpath": [=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.0=
3,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.mark_page_accessed.pageca=
che_get_page.grab_cache_page_write_begin.simple_write_begin.generic_perform=
_write": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.03=0A  ]=
,=0A  "perf-profile.cpu-cycles.dcache_dir_open.finish_open.do_last.path_ope=
nat.do_filp_open": [=0A    0.04,=0A    0.04,=0A    0.03,=0A    0.03,=0A    =
0.03=0A  ],=0A  "perf-profile.cpu-cycles.generic_permission.inode_permissio=
n.link_path_walk.path_openat.do_filp_open": [=0A    0.04,=0A    0.03,=0A   =
 0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.complete_=
walk.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.04,=0A    0.0=
3,=0A    0.04,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles._=
_inode_permission.inode_permission.may_open.do_last.path_openat": [=0A    0=
=2E04,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__list_add.inode_sb_list_add.new_inode.ramfs_get_inode.ramfs=
_mknod": [=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.03=0A  ]=
,=0A  "perf-profile.cpu-cycles.iov_iter_fault_in_readable.__generic_file_wr=
ite_iter.generic_file_write_iter.new_sync_write.vfs_write": [=0A    0.04,=
=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.simple_getattr.vfs_getattr_nosec.vfs_getattr.vfs_fstat.SYSC_newfst=
at": [=0A    0.04,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A=
  "perf-profile.cpu-cycles.lockref_get_not_dead.unlazy_walk.lookup_fast.pat=
h_lookupat.filename_lookup": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.=
04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.dput.terminate_walk.path=
_lookupat.filename_lookup.user_path_at_empty": [=0A    0.03,=0A    0.03,=0A=
    0.04,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.selinu=
x_task_kill.check_kill_permission.group_send_sig_info.kill_pid_info.SYSC_ki=
ll": [=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.04,=0A    0.05=0A  ],=0A=
  "perf-profile.cpu-cycles.lockref_put_or_lock.dput.terminate_walk.path_loo=
kupat.filename_lookup": [=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.03,=
=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.mutex_unlock.path_lookupat.=
filename_lookup.user_path_at_empty.user_path_at": [=0A    0.03,=0A    0.03,=
=0A    0.04,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.mig=
ht_fault.SYSC_newstat.sys_newstat.system_call_fastpath.__xstat64": [=0A    =
0.03,=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profi=
le.cpu-cycles.put_page.delete_from_page_cache.truncate_inode_page.truncate_=
inode_pages_range.truncate_inode_pages_final": [=0A    0.03,=0A    0.03,=0A=
    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__migh=
t_sleep.kmem_cache_alloc.getname_flags.user_path_at_empty.user_path_at": [=
=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04=0A  ],=0A  "per=
f-profile.cpu-cycles.put_page.new_sync_read.vfs_read.sys_pread64.system_cal=
l_fastpath": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04,=0A    0.04=
=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_lock_irq.delete_from_page_ca=
che.truncate_inode_page.truncate_inode_pages_range.truncate_inode_pages_fin=
al": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A=
  "perf-profile.cpu-cycles.sys_pread64.system_call_fastpath.pread64": [=0A =
   0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.selinux_sb_statfs.security_sb_statfs.statfs_by_dentry.vfs_=
statfs.user_statfs": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A  =
  0.03=0A  ],=0A  "perf-profile.cpu-cycles.__srcu_read_lock.vfs_write.sys_p=
write64.system_call_fastpath.__libc_pwrite": [=0A    0.03,=0A    0.03,=0A  =
  0.04,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.inode_do=
init_with_dentry.selinux_d_instantiate.security_d_instantiate.d_instantiate=
=2Eramfs_mknod": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03,=0A    0.=
03=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_unlock.__dentry_kill.dput.=
dcache_dir_close.__fput": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.lookup_page_cgroup.__mem_cg=
roup_commit_charge.mem_cgroup_charge_file.__add_to_page_cache_locked.add_to=
_page_cache_lru": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.04,=0A    0=
=2E03=0A  ],=0A  "perf-profile.cpu-cycles.map_id_up.cp_new_stat.SYSC_newsta=
t.sys_newstat.system_call_fastpath": [=0A    0.03,=0A    0.03,=0A    0.04,=
=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.group_send_sig_=
info.SYSC_kill.sys_kill.system_call_fastpath.kill": [=0A    0.03,=0A    0.0=
3,=0A    0.02,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.s=
ysret_check.__xstat64": [=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.04,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__list_add.d_alloc.dcache_d=
ir_open.do_dentry_open.finish_open": [=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.generic_permiss=
ion.__inode_permission.inode_permission.may_open.do_last": [=0A    0.03,=0A=
    0.03,=0A    0.03,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-profile.cpu-c=
ycles.current_has_perm.security_task_kill.check_kill_permission.group_send_=
sig_info.kill_pid_info": [=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04,=
=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.putname.user_path_at.vfs_fs=
tatat.SYSC_newstat.sys_newstat": [=0A    0.03,=0A    0.04,=0A    0.03,=0A  =
  0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.user_path_at.SYSC_ne=
wstat.sys_newstat.system_call_fastpath.__xstat64": [=0A    0.03,=0A    0.03=
,=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.me=
m_cgroup_charge_file.__add_to_page_cache_locked.add_to_page_cache_lru.pagec=
ache_get_page.grab_cache_page_write_begin": [=0A    0.03,=0A    0.03,=0A   =
 0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.get_pfnbl=
ock_flags_mask.free_hot_cold_page.free_hot_cold_page_list.release_pages.__p=
agevec_release": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.=
03=0A  ],=0A  "perf-profile.cpu-cycles.d_instantiate.simple_lookup.lookup_r=
eal.__lookup_hash.lookup_slow": [=0A    0.03,=0A    0.03,=0A    0.03,=0A   =
 0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.security_file_permiss=
ion.sys_getdents.system_call_fastpath": [=0A    0.03,=0A    0.02,=0A    0.0=
3,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.do_unlinkat.s=
ys_unlink.system_call_fastpath.unlink": [=0A    0.03,=0A    0.03,=0A    0.0=
3,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.d_set_d_op.si=
mple_lookup.lookup_real.__lookup_hash.lookup_slow": [=0A    0.03,=0A    0,=
=0A    0,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__sb_start_write.m=
nt_want_write.do_last.path_openat.do_filp_open": [=0A    0.03,=0A    0.03,=
=0A    0.04,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.use=
r_path_at_empty.vfs_fstatat.SYSC_newstat.sys_newstat.system_call_fastpath":=
 [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "p=
erf-profile.cpu-cycles.inode_permission.do_last.path_openat.do_filp_open.do=
_sys_open": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.04,=0A    0.04=0A=
  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_page_lruvec.release_pages.__pa=
gevec_release.truncate_inode_pages_range.truncate_inode_pages_final": [=0A =
   0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.do_sys_open.system_call_fastpath": [=0A    0.03,=0A    0.0=
3,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.g=
etname_flags.getname.do_sys_open.sys_open.system_call_fastpath": [=0A    0.=
03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.simple_getattr.vfs_getattr_nosec.vfs_getattr.vfs_fstatat.SYSC=
_newstat": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A =
 ],=0A  "perf-profile.cpu-cycles.iput.do_unlinkat.sys_unlink.system_call_fa=
stpath.unlink": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.0=
3=0A  ],=0A  "perf-profile.cpu-cycles.unlock_page.truncate_inode_pages_rang=
e.truncate_inode_pages_final.evict.iput": [=0A    0.03,=0A    0.03,=0A    0=
=2E03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__d_insta=
ntiate.d_instantiate.simple_lookup.lookup_real.__lookup_hash": [=0A    0.03=
,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.c=
pu-cycles.lookup_slow.path_lookupat.filename_lookup.user_path_at_empty.user=
_path_at": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.04=0A =
 ],=0A  "perf-profile.cpu-cycles.fd_install.sys_openat.system_call_fastpath=
": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.03=0A  ],=0A  =
"perf-profile.cpu-cycles.link_path_walk.path_lookupat.filename_lookup.user_=
path_parent.SYSC_renameat2": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.=
03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.path_init.filename_looku=
p.user_path_at_empty.user_path_at.vfs_fstatat": [=0A    0.03,=0A    0.03,=
=0A    0.03,=0A    0.04,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.pat=
h_get.finish_open.do_last.path_openat.do_filp_open": [=0A    0.03,=0A    0.=
04,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.=
readdir@plt": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=
=0A  ],=0A  "perf-profile.cpu-cycles.gettimeofday@plt": [=0A    0.03,=0A   =
 0.03,=0A    0.02,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycl=
es.mntput_no_expire.mntput.__fput.____fput.task_work_run": [=0A    0.03,=0A=
    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-c=
ycles.dput.dcache_dir_close.__fput.____fput.task_work_run": [=0A    0.03,=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.__srcu_read_unlock.fsnotify.vfs_write.sys_pwrite64.system_call_fas=
tpath": [=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.03=0A  ],=
=0A  "perf-profile.cpu-cycles.lookup_slow.filename_lookup.user_path_at_empt=
y.user_path_at.vfs_fstatat": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.=
03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__set_page_dirty_no_writ=
eback.set_page_dirty.simple_write_end.generic_perform_write.__generic_file_=
write_iter": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=
=0A  ],=0A  "perf-profile.cpu-cycles.__d_instantiate.simple_lookup.lookup_r=
eal.__lookup_hash.lookup_slow": [=0A    0.03,=0A    0.03,=0A    0.03,=0A   =
 0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__d_alloc.d_alloc.loo=
kup_dcache.do_last.path_openat": [=0A    0.03,=0A    0.03,=0A    0.03,=0A  =
  0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_trylock.dp=
ut.dcache_dir_close.__fput.____fput": [=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.file_remove_sui=
d.__generic_file_write_iter.generic_file_write_iter.new_sync_write.vfs_writ=
e": [=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A =
 "perf-profile.cpu-cycles.do_filp_open.do_sys_open.sys_openat.system_call_f=
astpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  =
],=0A  "perf-profile.cpu-cycles.release_pages.pagevec_lru_move_fn.__lru_cac=
he_add.lru_cache_add.add_to_page_cache_lru": [=0A    0.03,=0A    0.03,=0A  =
  0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.lockref_=
get.do_dentry_open.finish_open.do_last.path_openat": [=0A    0.03,=0A    0.=
03,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.=
truncate_inode_pages_final.evict.iput.do_unlinkat.sys_unlink": [=0A    0.03=
,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.c=
pu-cycles.rcu_check_callbacks.update_process_times.tick_sched_handle.tick_s=
ched_timer.__run_hrtimer": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=
,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.do_notify_resume.close": [=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "per=
f-profile.cpu-cycles.vfs_unlink.do_unlinkat.sys_unlink.system_call_fastpath=
=2Eunlink": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A=
  ],=0A  "perf-profile.cpu-cycles.lockref_put_or_lock.dput.path_lookupat.fi=
lename_lookup.user_path_at_empty": [=0A    0.03,=0A    0.03,=0A    0.03,=0A=
    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.mutex_lock_killabl=
e.sys_getdents.system_call_fastpath": [=0A    0.03,=0A    0.03,=0A    0.04,=
=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.k=
mem_cache_alloc.getname_flags.getname.do_sys_open": [=0A    0.03,=0A    0.0=
3,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.m=
ntget.path_get.do_dentry_open.finish_open.do_last": [=0A    0.03,=0A    0.0=
3,=0A    0.02,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles._=
_fsnotify_parent.security_file_permission.iterate_dir.sys_getdents.system_c=
all_fastpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=
=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_alloc_security.security_f=
ile_alloc.get_empty_filp.path_openat.do_filp_open": [=0A    0.03,=0A    0.0=
3,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.m=
ntput_no_expire.terminate_walk.do_last.path_openat.do_filp_open": [=0A    0=
=2E03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.map_id_up.from_kuid_munged.SYSC_kill.sys_kill.system_call_fa=
stpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ]=
,=0A  "perf-profile.cpu-cycles.statfs_by_dentry.vfs_statfs.user_statfs.SYSC=
_statfs.sys_statfs": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A  =
  0.03=0A  ],=0A  "perf-profile.cpu-cycles.group_send_sig_info.kill_pid_inf=
o.SYSC_kill.sys_kill.system_call_fastpath": [=0A    0.03,=0A    0.03,=0A   =
 0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.vfs_getat=
tr_nosec.vfs_getattr.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A    0.03,=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.04=0A  ],=0A  "perf-profile.cp=
u-cycles.pagecache_get_page.new_sync_read.vfs_read.sys_pread64.system_call_=
fastpath": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.03=0A =
 ],=0A  "perf-profile.cpu-cycles._raw_spin_unlock.__dentry_kill.dput.termin=
ate_walk.path_lookupat": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__d_lookup.d_lookup.lookup_=
dcache.__lookup_hash.lookup_slow": [=0A    0.03,=0A    0.03,=0A    0.03,=0A=
    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.complete_walk.path=
_lookupat.filename_lookup.user_path_at_empty.user_path_at": [=0A    0.03,=
=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.selinux_file_free_security.__fput.____fput.task_work_run.do_notify=
_resume": [=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.04=0A  =
],=0A  "perf-profile.cpu-cycles.process_measurement.do_last.path_openat.do_=
filp_open.do_sys_open": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.__dec_zone_state.__dec_zone=
_page_state.__delete_from_page_cache.delete_from_page_cache.truncate_inode_=
page": [=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=
=0A  "perf-profile.cpu-cycles.groups_search.generic_permission.__inode_perm=
ission.inode_permission.link_path_walk": [=0A    0.03,=0A    0.02,=0A    0.=
02,=0A    0.02,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_lo=
ck_irq.clear_inode.evict.iput.do_unlinkat": [=0A    0.03,=0A    0.03,=0A   =
 0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.rw_verify=
_area.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=0A    0=
=2E03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.dput.terminate_walk.do_last.path_openat.do_filp_open": [=0A =
   0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.kfree.security_file_free.__fput.____fput.task_work_run": [=
=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.__sb_end_write.vfs_write.sys_pwrite64.system_call_fast=
path.__libc_pwrite": [=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.02,=0A  =
  0.03=0A  ],=0A  "perf-profile.cpu-cycles.__d_free.__dentry_kill.dput.dcac=
he_dir_close.__fput": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A =
   0.03=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_trylock.dput.terminat=
e_walk.path_lookupat.filename_lookup": [=0A    0.03,=0A    0.02,=0A    0.02=
,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.SYSC_newstat.s=
ys_newstat.system_call_fastpath.__xstat64": [=0A    0.03,=0A    0.03,=0A   =
 0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.file_upda=
te_time.__generic_file_write_iter.generic_file_write_iter.new_sync_write.vf=
s_write": [=0A    0.03,=0A    0.03,=0A    0.04,=0A    0.03,=0A    0.02=0A  =
],=0A  "perf-profile.cpu-cycles.__radix_tree_delete_node.__delete_from_page=
_cache.delete_from_page_cache.truncate_inode_page.truncate_inode_pages_rang=
e": [=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02=0A  ],=0A =
 "perf-profile.cpu-cycles.do_filp_open.sys_openat.system_call_fastpath": [=
=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.d_flags_for_inode.d_instantiate.simple_lookup.lookup_r=
eal.__lookup_hash": [=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03,=0A   =
 0.02=0A  ],=0A  "perf-profile.cpu-cycles.mntput_no_expire.mntput.terminate=
_walk.do_last.path_openat": [=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.0=
3,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin_lock_irqsave.pa=
gevec_lru_move_fn.lru_add_drain_cpu.__pagevec_release.truncate_inode_pages_=
range": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.SYSC_newstat.system_call_fastpath.__xstat64":=
 [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "p=
erf-profile.cpu-cycles.security_inode_getattr.vfs_fstat.SYSC_newfstat.sys_n=
ewfstat.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    =
0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.get_unused_fd_flags.do=
_sys_open.sys_open.system_call_fastpath.open64": [=0A    0.02,=0A    0.03,=
=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.mut=
ex_unlock.new_sync_write.vfs_write.sys_pwrite64.system_call_fastpath": [=0A=
    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-p=
rofile.cpu-cycles.find_next_zero_bit.__alloc_fd.get_unused_fd_flags.do_sys_=
open.sys_openat": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0=
=2E03=0A  ],=0A  "perf-profile.cpu-cycles.wait_for_stable_page.grab_cache_p=
age_write_begin.simple_write_begin.generic_perform_write.__generic_file_wri=
te_iter": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.03=0A  =
],=0A  "perf-profile.cpu-cycles.__fsnotify_parent.do_dentry_open.finish_ope=
n.do_last.path_openat": [=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.security_file_open.finish_o=
pen.do_last.path_openat.do_filp_open": [=0A    0.02,=0A    0.02,=0A    0.03=
,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.kfree.selinux_=
file_free_security.security_file_free.put_filp.path_openat": [=0A    0.02,=
=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cp=
u-cycles.iov_iter_copy_from_user_atomic.__generic_file_write_iter.generic_f=
ile_write_iter.new_sync_write.vfs_write": [=0A    0.02,=0A    0.03,=0A    0=
=2E02,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__fd_inst=
all.fd_install.do_sys_open.sys_openat.system_call_fastpath": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.radix_tree_lookup_slot.pagecache_get_page.generic_file_read_iter.n=
ew_sync_read.vfs_read": [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.lookup_page_cgroup.__mem_cg=
roup_uncharge_common.mem_cgroup_uncharge_cache_page.delete_from_page_cache.=
truncate_inode_page": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A =
   0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mnt_want_write.touch_atime.ge=
neric_file_read_iter.new_sync_read.vfs_read": [=0A    0.02,=0A    0.02,=0A =
   0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.current=
_fs_time.touch_atime.iterate_dir.sys_getdents.system_call_fastpath": [=0A  =
  0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pro=
file.cpu-cycles.selinux_d_instantiate.d_instantiate.simple_lookup.lookup_re=
al.__lookup_hash": [=0A    0.02,=0A    0.03,=0A    0.04,=0A    0.04,=0A    =
0.04=0A  ],=0A  "perf-profile.cpu-cycles.unlazy_walk.path_lookupat.filename=
_lookup.user_path_at_empty.user_path_at": [=0A    0.02,=0A    0.02,=0A    0=
=2E02,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.cpu-cycles.path_look=
upat.user_path_at_empty.user_path_at.vfs_fstatat.SYSC_newstat": [=0A    0.0=
2,=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A  "perf-profile.=
cpu-cycles.getname_flags.user_path_at.vfs_fstatat.SYSC_newstat.sys_newstat"=
: [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.03=0A  ],=0A  "=
perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc=
_pages_current.new_slab.__slab_alloc": [=0A    0.02,=0A    0.02,=0A    0.02=
,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.map_id_up.SYSC=
_kill.sys_kill.system_call_fastpath.kill": [=0A    0.02,=0A    0.03,=0A    =
0.03,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__sb_end_w=
rite.mnt_drop_write.do_last.path_openat.do_filp_open": [=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycle=
s.lookup_dcache.__lookup_hash.lookup_slow.path_lookupat.filename_lookup": [=
=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.security_file_permission.rw_verify_area.vfs_read.sys_p=
read64.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0=
=2E02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.dput.__fput.____fput.=
task_work_run.do_notify_resume": [=0A    0.02,=0A    0.02,=0A    0.02,=0A  =
  0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_alloc_=
security.security_inode_alloc.inode_init_always.alloc_inode.new_inode_pseud=
o": [=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.03=0A  ],=0A =
 "perf-profile.cpu-cycles.kick_process.task_work_add.fput.filp_close.__clos=
e_fd": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.__fsnotify_parent.security_file_open.do_dentr=
y_open.finish_open.do_last": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.=
02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.strncpy_from_user.user_p=
ath_at_empty.user_path_at.vfs_fstatat.SYSC_newstat": [=0A    0.02,=0A    0.=
02,=0A    0.02,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.=
security_d_instantiate.simple_lookup.lookup_real.__lookup_hash.lookup_slow"=
: [=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "=
perf-profile.cpu-cycles.d_lookup.lookup_dcache.do_last.path_openat.do_filp_=
open": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.lookup_fast.link_path_walk.path_lookupat.file=
name_lookup.user_path_parent": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.locks_remove_file.____=
fput.task_work_run.do_notify_resume.int_signal": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.fil=
p_close.sys_close.system_call_fastpath.close": [=0A    0.02,=0A    0.02,=0A=
    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__migh=
t_sleep.kmem_cache_alloc.get_empty_filp.path_openat.do_filp_open": [=0A    =
0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profi=
le.cpu-cycles.handle_dots.path_lookupat.filename_lookup.user_path_at_empty.=
user_path_at": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.03=
=0A  ],=0A  "perf-profile.cpu-cycles.mutex_unlock.selinux_d_instantiate.sec=
urity_d_instantiate.d_instantiate.ramfs_mknod": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.cur=
rent_kernel_time.current_fs_time.touch_atime.generic_file_read_iter.new_syn=
c_read": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.03=0A  ]=
,=0A  "perf-profile.cpu-cycles.bit_waitqueue.inode_wait_for_writeback.evict=
=2Eiput.do_unlinkat": [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.03,=0A =
   0.02=0A  ],=0A  "perf-profile.cpu-cycles.ima_file_check.path_openat.do_f=
ilp_open.do_sys_open.sys_openat": [=0A    0.02,=0A    0.02,=0A    0.03,=0A =
   0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__fsnotify_parent.s=
ecurity_file_permission.rw_verify_area.vfs_read.sys_pread64": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.cp_new_stat.sys_newstat.system_call_fastpath.__xstat64": [=0A    0=
=2E02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__slab_free.kmem_cache_free.radix_tree_node_rcu_free.rcu_noc=
b_kthread.kthread": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A   =
 0.02=0A  ],=0A  "perf-profile.cpu-cycles.always_delete_dentry.terminate_wa=
lk.path_lookupat.filename_lookup.user_path_at_empty": [=0A    0.02,=0A    0=
=2E01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycl=
es.mark_page_accessed.generic_file_read_iter.new_sync_read.vfs_read.sys_pre=
ad64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.try_module_get.do_dentry_open.finish_open.do_=
last.path_openat": [=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.01,=0A    =
0.01=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_permission.rw_verify_=
area.vfs_read.sys_pread64.system_call_fastpath": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.03,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__s=
lab_alloc.kmem_cache_alloc.__d_alloc.d_alloc.lookup_dcache": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.alloc_inode.new_inode_pseudo.new_inode.ramfs_get_inode.ramfs_mknod=
": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  =
"perf-profile.cpu-cycles.__page_cache_alloc.pagecache_get_page.grab_cache_p=
age_write_begin.simple_write_begin.generic_perform_write": [=0A    0.02,=0A=
    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-c=
ycles.d_alloc.lookup_dcache.__lookup_hash.lookup_slow.path_lookupat": [=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.__d_drop.dput.dcache_dir_close.__fput.____fput": [=0A    0=
=2E02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__mnt_want_write.mnt_want_write.utimes_common.do_utimes.sys_=
utime": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.kill_pid_info.sys_kill.system_call_fastpath.k=
ill": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.inode_permission.link_path_walk.path_lookupat=
=2Efilename_lookup.user_path_at_empty": [=0A    0.02,=0A    0.02,=0A    0.0=
2,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.balance_dirty=
_pages_ratelimited.__generic_file_write_iter.generic_file_write_iter.new_sy=
nc_write.vfs_write": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.03,=0A  =
  0.03=0A  ],=0A  "perf-profile.cpu-cycles.unlink": [=0A    0.02,=0A    0.0=
2,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.c=
ap_inode_need_killpriv.file_remove_suid.__generic_file_write_iter.generic_f=
ile_write_iter.new_sync_write": [=0A    0.02,=0A    0.02,=0A    0.02,=0A   =
 0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.memalign@plt": [=0A  =
  0.02,=0A    0.03,=0A    0.03,=0A    0.02,=0A    0.03=0A  ],=0A  "perf-pro=
file.cpu-cycles.sysret_signal.close": [=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.int_restore_res=
t.close": [=0A    0.02,=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03=0A  =
],=0A  "perf-profile.cpu-cycles.strcasecmp@plt": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.sta=
tvfs": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.memcpy@plt": [=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.opendir": =
[=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "pe=
rf-profile.cpu-cycles.retint_swapgs.close": [=0A    0.02,=0A    0.02,=0A   =
 0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.generic_e=
xec_single.smp_call_function_single.smp_call_function_many.native_flush_tlb=
_others.flush_tlb_page": [=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.native_iret.close": [=0A    0.02,=0A    0,=0A    0.02,=0A    0,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.simple_write_begin.__generi=
c_file_write_iter.generic_file_write_iter.new_sync_write.vfs_write": [=0A  =
  0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pro=
file.cpu-cycles.iov_iter_init.vfs_read.sys_pread64.system_call_fastpath.pre=
ad64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.page_mapping.simple_write_end.generic_perform=
_write.__generic_file_write_iter.generic_file_write_iter": [=0A    0.02,=0A=
    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-c=
ycles.dnotify_flush.__close_fd.sys_close.system_call_fastpath.close": [=0A =
   0.02,=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.__pagevec_lru_add_fn.pagevec_lru_move_fn.lru_add_drain_cpu=
=2E__pagevec_release.truncate_inode_pages_range": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mem=
_cgroup_try_charge_mm.mem_cgroup_charge_file.__add_to_page_cache_locked.add=
_to_page_cache_lru.pagecache_get_page": [=0A    0.02,=0A    0.03,=0A    0.0=
2,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.follow_manage=
d.lookup_slow.path_lookupat.filename_lookup.user_path_at_empty": [=0A    0.=
02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.__inc_zone_state.__inc_zone_page_state.__add_to_page_cache_lo=
cked.add_to_page_cache_lru.pagecache_get_page": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.avc=
_policy_seqno.security_file_open.do_dentry_open.finish_open.do_last": [=0A =
   0.02,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.vfs_rename.SYSC_renameat2.sys_rename.system_call_fastpath.=
rename": [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.02=0A  ]=
,=0A  "perf-profile.cpu-cycles.generic_fillattr.vfs_getattr_nosec.vfs_getat=
tr.vfs_fstatat.SYSC_newstat": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0=
=2E02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.sys_newfstat.__fxstat=
64": [=0A    0.02,=0A    0.03,=0A    0.02,=0A    0.03,=0A    0.02=0A  ],=0A=
  "perf-profile.cpu-cycles.do_filp_open.do_sys_open.sys_open.system_call_fa=
stpath.open64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.0=
2=0A  ],=0A  "perf-profile.cpu-cycles.d_delete.vfs_unlink.do_unlinkat.sys_u=
nlink.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.=
02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.find_vpid.SYSC_kill.sys_=
kill.system_call_fastpath.kill": [=0A    0.02,=0A    0.03,=0A    0.02,=0A  =
  0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.grab_cache_page_writ=
e_begin.simple_write_begin.generic_perform_write.__generic_file_write_iter.=
generic_file_write_iter": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.map_id_up.cp_new_stat.SYSC_=
newfstat.sys_newfstat.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A  =
  0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.notify_c=
hange.utimes_common.do_utimes.sys_utime.system_call_fastpath": [=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.c=
pu-cycles.terminate_walk.do_last.path_openat.do_filp_open.do_sys_open": [=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.dput.path_lookupat.filename_lookup.user_path_at_empty.=
user_path_at": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.mntput_no_expire.__fput.____fput.task_=
work_run.do_notify_resume": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.0=
2,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mutex_init.get_empty_fi=
lp.path_openat.do_filp_open.do_sys_open": [=0A    0.02,=0A    0.02,=0A    0=
=2E02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mark_in=
ode_dirty.update_time.touch_atime.generic_file_read_iter.new_sync_read": [=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "per=
f-profile.cpu-cycles.__might_sleep.kmem_cache_alloc.__d_alloc.d_alloc.dcach=
e_dir_open": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.radix_tree_lookup_slot.pagecache_get_p=
age.grab_cache_page_write_begin.simple_write_begin.generic_perform_write": =
[=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "pe=
rf-profile.cpu-cycles.new_slab.__slab_alloc.kmem_cache_alloc.__d_alloc.d_al=
loc": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.restore_args.close": [=0A    0.02,=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.cp=
_new_stat.sys_newfstat.system_call_fastpath.__fxstat64": [=0A    0.02,=0A  =
  0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cyc=
les.d_instantiate.lookup_real.__lookup_hash.lookup_slow.path_lookupat": [=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.pagevec_lru_move_fn.lru_add_drain_cpu.__pagevec_releas=
e.truncate_inode_pages_range.truncate_inode_pages_final": [=0A    0.02,=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cy=
cles.d_alloc.__lookup_hash.lookup_slow.path_lookupat.filename_lookup": [=0A=
    0.02,=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-p=
rofile.cpu-cycles.mntput_no_expire.mntput.path_put.vfs_fstatat.SYSC_newstat=
": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  =
"perf-profile.cpu-cycles.____fput.do_notify_resume.int_signal.close": [=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.security_inode_permission.__inode_permission.inode_permiss=
ion.link_path_walk.path_lookupat": [=0A    0.02,=0A    0.01,=0A    0.02,=0A=
    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.list_del.dput.dcac=
he_dir_close.__fput.____fput": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.security_file_permissi=
on.vfs_read.sys_pread64.system_call_fastpath.pread64": [=0A    0.02,=0A    =
0.01,=0A    0.01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycle=
s.from_kgid_munged.SYSC_newstat.sys_newstat.system_call_fastpath.__xstat64"=
: [=0A    0.02,=0A    0.03,=0A    0.03,=0A    0.03,=0A    0.02=0A  ],=0A  "=
perf-profile.cpu-cycles.finish_open.do_last.path_openat.do_filp_open.do_sys=
_open": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.page_mapping.grab_cache_page_write_begin.simp=
le_write_begin.generic_perform_write.__generic_file_write_iter": [=0A    0.=
02,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.strncpy_from_user.getname.do_sys_open.sys_openat.system_call_=
fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A =
 ],=0A  "perf-profile.cpu-cycles._raw_spin_trylock.dcache_dir_close.__fput.=
____fput.task_work_run": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.fd_install.sys_open.system_=
call_fastpath.open64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A=
    0.02=0A  ],=0A  "perf-profile.cpu-cycles.d_alloc.dcache_dir_open.do_den=
try_open.finish_open.do_last": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.do_filp_open.sys_open.=
system_call_fastpath.open64": [=0A    0.02,=0A    0.02,=0A    0.01,=0A    0=
=2E01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.might_f=
ault.sys_getdents.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.=
02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inod=
e_alloc_security.inode_init_always.alloc_inode.new_inode_pseudo.new_inode":=
 [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "p=
erf-profile.cpu-cycles.kmem_cache_alloc.getname_flags.user_path_at_empty.us=
er_path_at.user_statfs": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.inode_has_perm.isra.32.secu=
rity_inode_getattr.vfs_getattr.vfs_fstatat.SYSC_newstat": [=0A    0.02,=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cy=
cles._raw_spin_trylock.terminate_walk.path_lookupat.filename_lookup.user_pa=
th_at_empty": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.current_kernel_time.touch_atime.iterat=
e_dir.sys_getdents.system_call_fastpath": [=0A    0.02,=0A    0.01,=0A    0=
=2E01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.res_count=
er_uncharge_until.res_counter_uncharge.mem_cgroup_uncharge_end.truncate_ino=
de_pages_range.truncate_inode_pages_final": [=0A    0.02,=0A    0.02,=0A   =
 0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mntput_no=
_expire.mntput.terminate_walk.path_lookupat.filename_lookup": [=0A    0.02,=
=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.lru_add_drain_cpu.__pagevec_release.truncate_inode_pages_range.tru=
ncate_inode_pages_final.evict": [=0A    0.02,=0A    0.02,=0A    0,=0A    0.=
02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.may_open.path_openat.do_=
filp_open.do_sys_open.sys_openat": [=0A    0.02,=0A    0.02,=0A    0.02,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.generic_file_read_=
iter.new_sync_read.vfs_read.sys_read.system_call_fastpath": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.__fd_install.do_sys_open.sys_openat.system_call_fastpath": [=0A   =
 0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__might_sleep.kmem_cache_alloc.__d_alloc.d_alloc.lookup_dcac=
he": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A=
  "perf-profile.cpu-cycles.fsnotify_clear_marks_by_inode.__fsnotify_inode_d=
elete.d_delete.vfs_unlink.do_unlinkat": [=0A    0.02,=0A    0.02,=0A    0.0=
1,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.path_openat.do_sys_open.s=
ys_openat.system_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A  =
  0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.pid_task.SYSC_kill.s=
ys_kill.system_call_fastpath.kill": [=0A    0.02,=0A    0.01,=0A    0.01,=
=0A    0,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_page_lr=
uvec.pagevec_lru_move_fn.lru_add_drain_cpu.__pagevec_release.truncate_inode=
_pages_range": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.from_kuid_munged.sys_kill.system_call_=
fastpath.kill": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.0=
2=0A  ],=0A  "perf-profile.cpu-cycles.iterate_dir.system_call_fastpath": [=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.sys_pread64.pread64": [=0A    0.02,=0A    0.02,=0A    =
0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mod_zone=
_page_state.release_pages.__pagevec_release.truncate_inode_pages_range.trun=
cate_inode_pages_final": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.d_rehash.lookup_real.__look=
up_hash.lookup_slow.path_lookupat": [=0A    0.02,=0A    0.01,=0A    0.02,=
=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__rmqueue.__all=
oc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page=
": [=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.02=0A  ],=0A  =
"perf-profile.cpu-cycles.mntput.vfs_fstatat.SYSC_newstat.sys_newstat.system=
_call_fastpath": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles.copy_page_to_iter_iovec.generic_file=
_read_iter.new_sync_read.vfs_read.sys_pread64": [=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.sys=
_pwrite64.system_call_fastpath.__libc_pwrite": [=0A    0.02,=0A    0.01,=0A=
    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__mutex_init.path_ope=
nat.do_filp_open.do_sys_open.sys_openat": [=0A    0.02,=0A    0.02,=0A    0=
=2E02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.ima_file_=
free.____fput.task_work_run.do_notify_resume.int_signal": [=0A    0.02,=0A =
   0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cy=
cles.new_sync_write.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwri=
te": [=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A=
  "perf-profile.cpu-cycles.find_next_zero_bit.__alloc_fd.get_unused_fd_flag=
s.do_sys_open.sys_open": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__call_rcu_nocb_enqueue.cal=
l_rcu_sched.selinux_inode_free_security.security_inode_free.__destroy_inode=
": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  =
"perf-profile.cpu-cycles.might_fault.SYSC_newfstat.sys_newfstat.system_call=
_fastpath.__fxstat64": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A=
    0.01=0A  ],=0A  "perf-profile.cpu-cycles.inode_has_perm.isra.32.selinux=
_file_open.security_file_open.do_dentry_open.finish_open": [=0A    0.02,=0A=
    0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-c=
ycles.__inc_zone_state.get_page_from_freelist.__alloc_pages_nodemask.alloc_=
pages_current.__page_cache_alloc": [=0A    0.02,=0A    0.02,=0A    0.01,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.policy_zonelist.al=
loc_pages_current.__page_cache_alloc.pagecache_get_page.grab_cache_page_wri=
te_begin": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A =
 ],=0A  "perf-profile.cpu-cycles.wait_for_stable_page.simple_write_begin.ge=
neric_perform_write.__generic_file_write_iter.generic_file_write_iter": [=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  "per=
f-profile.cpu-cycles.fsnotify.do_sys_open.sys_open.system_call_fastpath.ope=
n64": [=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.__lookup_hash.lookup_slow.path_lookupat.filen=
ame_lookup.user_path_at_empty": [=0A    0.02,=0A    0.01,=0A    0.01,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.selinux_task_kill.security_task_k=
ill.check_kill_permission.group_send_sig_info.kill_pid_info": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.__wake_up_bit.wake_up_bit.evict.iput.do_unlinkat": [=0A    0.02,=
=0A    0.01,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-c=
ycles.pid_vnr.sys_kill.system_call_fastpath.kill": [=0A    0.02,=0A    0.02=
,=0A    0.01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mn=
tput.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.02,=0A    0.0=
1,=0A    0.01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.m=
utex_unlock.path_openat.do_filp_open.do_sys_open.sys_open": [=0A    0.02,=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.run_timer_softirq.__do_softirq.irq_exit.smp_apic_timer_interrupt.a=
pic_timer_interrupt": [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A =
   0.02=0A  ],=0A  "perf-profile.cpu-cycles.evict.iput.do_unlinkat.sys_unli=
nk.system_call_fastpath": [=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.01,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.zone_statistics.get_page_fr=
om_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc":=
 [=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "p=
erf-profile.cpu-cycles.__d_drop.dput.terminate_walk.do_last.path_openat": [=
=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "per=
f-profile.cpu-cycles.__fsnotify_parent.do_sys_open.sys_openat.system_call_f=
astpath": [=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02,=0A    0.02=0A  =
],=0A  "perf-profile.cpu-cycles.iov_iter_advance.generic_perform_write.__ge=
neric_file_write_iter.generic_file_write_iter.new_sync_write": [=0A    0.02=
,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.c=
pu-cycles.iov_iter_advance.__generic_file_write_iter.generic_file_write_ite=
r.new_sync_write.vfs_write": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.=
01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__fput.task_work_run.do_=
notify_resume.int_signal.close": [=0A    0.01,=0A    0.02,=0A    0.01,=0A  =
  0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.follow_managed.path_=
lookupat.filename_lookup.user_path_at_empty.user_path_at": [=0A    0.01,=0A=
    0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-c=
ycles.free_hot_cold_page_list.release_pages.__pagevec_release.truncate_inod=
e_pages_range.truncate_inode_pages_final": [=0A    0.01,=0A    0.01,=0A    =
0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles._copy_to_u=
ser.SYSC_newfstat.sys_newfstat.system_call_fastpath.__fxstat64": [=0A    0.=
01,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.security_task_kill.group_send_sig_info.kill_pid_info.SYSC_kil=
l.sys_kill": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.02=
=0A  ],=0A  "perf-profile.cpu-cycles.radix_tree_node_alloc.__radix_tree_cre=
ate.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page": [=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mntput.____fput.task_work_r=
un.do_notify_resume.int_signal": [=0A    0.01,=0A    0.01,=0A    0.01,=0A  =
  0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__d_free.dentry_free=
=2E__dentry_kill.dput.dcache_dir_close": [=0A    0.01,=0A    0.01,=0A    0.=
02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.security_ino=
de_permission.__inode_permission.inode_permission.link_path_walk.path_opena=
t": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A =
 "perf-profile.cpu-cycles.from_kuid_munged.SYSC_newstat.sys_newstat.system_=
call_fastpath.__xstat64": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.inode_permission.link_path_=
walk.path_openat.do_filp_open.do_sys_open": [=0A    0.01,=0A    0.02,=0A   =
 0.01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__d_rehas=
h.d_rehash.simple_lookup.lookup_real.__lookup_hash": [=0A    0.01,=0A    0.=
01,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.=
get_mem_cgroup_from_mm.mem_cgroup_charge_file.__add_to_page_cache_locked.ad=
d_to_page_cache_lru.pagecache_get_page": [=0A    0.01,=0A    0.02,=0A    0.=
02,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.iov_iter_ini=
t.vfs_write.sys_pwrite64.system_call_fastpath.__libc_pwrite": [=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.d_alloc.do_dentry_open.finish_open.do_last.path_openat": [=0A    0=
=2E01,=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__d_lookup.d_lookup.lookup_dcache.__lookup_hash.do_unlinkat"=
: [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "=
perf-profile.cpu-cycles.dcache_dir_open.do_dentry_open.finish_open.do_last.=
path_openat": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.native_write_msr_safe.lapic_next_deadl=
ine.clockevents_program_event.tick_program_event.hrtimer_interrupt": [=0A  =
  0.01,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.si=
mple_lookup.lookup_real.__lookup_hash.lookup_slow.path_lookupat": [=0A    0=
=2E01,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.path_init.path_lookupat.filename_lookup.user_path_parent.do_=
unlinkat": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A =
 ],=0A  "perf-profile.cpu-cycles.security_file_free.____fput.task_work_run.=
do_notify_resume.int_signal": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.map_id_down.inode_ini=
t_always.alloc_inode.new_inode_pseudo.new_inode": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.fsn=
otify_find_inode_mark.filp_close.__close_fd.sys_close.system_call_fastpath"=
: [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "=
perf-profile.cpu-cycles.__percpu_counter_add.path_openat.do_filp_open.do_sy=
s_open.sys_openat": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.02,=0A   =
 0.02=0A  ],=0A  "perf-profile.cpu-cycles.__d_drop.dput.do_unlinkat.sys_unl=
ink.system_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.02=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_update_lru_size=
=2Erelease_pages.__pagevec_release.truncate_inode_pages_range.truncate_inod=
e_pages_final": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles.__dec_zone_state.__delete_from_page_c=
ache.delete_from_page_cache.truncate_inode_page.truncate_inode_pages_range"=
: [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "=
perf-profile.cpu-cycles.mutex_lock.generic_file_write_iter.new_sync_write.v=
fs_write.sys_pwrite64": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=
=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__mark_inode_dirty.simple_s=
etattr.notify_change.utimes_common.do_utimes": [=0A    0.01,=0A    0.01,=0A=
    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mntput=
=2Epath_lookupat.filename_lookup.user_path_at_empty.user_path_at": [=0A    =
0.01,=0A    0,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.__mnt_want_write.touch_atime.iterate_dir.sys_getdents.system_cal=
l_fastpath": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.might_fault.filldir.dcache_readdir.ite=
rate_dir.sys_getdents": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.map_id_up.from_kuid_munged.=
cp_new_stat.SYSC_newstat.sys_newstat": [=0A    0.01,=0A    0.01,=0A    0.01=
,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__mod_zone_pag=
e_state.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current._=
_page_cache_alloc": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.in_group_p.generic_permission.__i=
node_permission.inode_permission.link_path_walk": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mem=
cpy.d_alloc.lookup_dcache.do_last.path_openat": [=0A    0.01,=0A    0.02,=
=0A    0.01,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.sys=
_pwrite64.__libc_pwrite": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.02,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.vfs_create.do_last.path_ope=
nat.do_filp_open.do_sys_open": [=0A    0.01,=0A    0,=0A    0.01,=0A    0.0=
2,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.might_fault=
=2Ecp_new_stat.SYSC_newstat.sys_newstat": [=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__sb_star=
t_write.mnt_want_write.do_unlinkat.sys_unlink.system_call_fastpath": [=0A  =
  0.01,=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-pro=
file.cpu-cycles.pid_task.kill_pid_info.SYSC_kill.sys_kill.system_call_fastp=
ath": [=0A    0.01,=0A    0,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  =
"perf-profile.cpu-cycles.memcg_check_events.__mem_cgroup_commit_charge.mem_=
cgroup_charge_file.__add_to_page_cache_locked.add_to_page_cache_lru": [=0A =
   0.01,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.mem_cgroup_charge_statistics.isra.20.__mem_cgroup_commit_c=
harge.mem_cgroup_charge_file.__add_to_page_cache_locked.add_to_page_cache_l=
ru": [=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A=
  "perf-profile.cpu-cycles.workingset_activation.mark_page_accessed.pagecac=
he_get_page.grab_cache_page_write_begin.simple_write_begin": [=0A    0.01,=
=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cp=
u-cycles.mem_cgroup_charge_statistics.isra.20.__mem_cgroup_uncharge_common.=
mem_cgroup_uncharge_cache_page.delete_from_page_cache.truncate_inode_page":=
 [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "p=
erf-profile.cpu-cycles.may_link.isra.33.selinux_inode_unlink.security_inode=
_unlink.vfs_unlink.do_unlinkat": [=0A    0.01,=0A    0.01,=0A    0.01,=0A  =
  0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.path_lookupat.filena=
me_lookup.user_path_at_empty.user_path_at.user_statfs": [=0A    0.01,=0A   =
 0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.ima_file_=
check.path_openat.do_filp_open.do_sys_open.sys_open": [=0A    0.01,=0A    0=
=2E01,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycl=
es.current_fs_time.iterate_dir.sys_getdents.system_call_fastpath": [=0A    =
0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profi=
le.cpu-cycles.__zone_watermark_ok.get_page_from_freelist.__alloc_pages_node=
mask.alloc_pages_current.__page_cache_alloc": [=0A    0.01,=0A    0.01,=0A =
   0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__percp=
u_counter_add.____fput.task_work_run.do_notify_resume.int_signal": [=0A    =
0.01,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profi=
le.cpu-cycles.current_fs_time.touch_atime.generic_file_read_iter.new_sync_r=
ead.vfs_read": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles._cond_resched.new_sync_read.vfs_read.s=
ys_pread64.system_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A =
   0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__might_sleep.might=
_fault.cp_new_stat.SYSC_newfstat.sys_newfstat": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.pol=
icy_zonelist.__page_cache_alloc.pagecache_get_page.grab_cache_page_write_be=
gin.simple_write_begin": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0,=0A =
   0.01=0A  ],=0A  "perf-profile.cpu-cycles.vfs_getattr_nosec.vfs_getattr.v=
fs_fstat.SYSC_newfstat.sys_newfstat": [=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mutex_lock.path=
_lookupat.filename_lookup.user_path_at_empty.user_path_at": [=0A    0.01,=
=0A    0.02,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.final_putname.putname.user_path_at_empty.user_path_at.vfs_fstatat"=
: [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "=
perf-profile.cpu-cycles.new_sync_read.sys_pread64.system_call_fastpath.prea=
d64": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.selinux_file_permission.security_file_permiss=
ion.rw_verify_area.vfs_read.sys_read": [=0A    0.01,=0A    0.01,=0A    0.01=
,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.may_delete.vfs=
_unlink.do_unlinkat.sys_unlink.system_call_fastpath": [=0A    0.01,=0A    0=
=2E01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycl=
es.mntput_no_expire.path_put.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A   =
 0.01,=0A    0.02,=0A    0.02,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.vfs_fstat.SYSC_newfstat.sys_newfstat.system_call_fastpath.__=
fxstat64": [=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.01,=0A    0.02=0A =
 ],=0A  "perf-profile.cpu-cycles.__percpu_counter_add.__sb_end_write.vfs_wr=
ite.sys_pwrite64.system_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.0=
1,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__d_lookup.d_=
lookup.lookup_dcache.do_last.path_openat": [=0A    0.01,=0A    0.01,=0A    =
0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__mark_ino=
de_dirty.update_time.file_update_time.__generic_file_write_iter.generic_fil=
e_write_iter": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0,=0A    0.01=0A=
  ],=0A  "perf-profile.cpu-cycles.memcg_check_events.__mem_cgroup_uncharge_=
common.mem_cgroup_uncharge_cache_page.delete_from_page_cache.truncate_inode=
_page": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles._copy_to_user.SYSC_newstat.sys_newstat.system=
_call_fastpath.__xstat64": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.02=
,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles._d_rehash.simple_lookup.lo=
okup_real.__lookup_hash.lookup_slow": [=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.copy_page_to_it=
er.new_sync_read.vfs_read.sys_pread64.system_call_fastpath": [=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.selinux_file_alloc_security.get_empty_filp.path_openat.do_filp_ope=
n.do_sys_open": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_getattr.security_inode_=
getattr.vfs_getattr.vfs_fstatat.SYSC_newstat": [=0A    0.01,=0A    0.01,=0A=
    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mnt_dr=
op_write.path_openat.do_filp_open.do_sys_open.sys_open": [=0A    0.01,=0A  =
  0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.selinux_file_p=
ermission.rw_verify_area.vfs_write.sys_pwrite64.system_call_fastpath": [=0A=
    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.page_mapping.set_page_dirty.simple_write_end.generic_perf=
orm_write.__generic_file_write_iter": [=0A    0.01,=0A    0,=0A    0.01,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__fd_install.fd_in=
stall.do_sys_open.sys_open.system_call_fastpath": [=0A    0.01,=0A    0.01,=
=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.complete_walk.path=
_openat.do_filp_open.do_sys_open.sys_openat": [=0A    0.01,=0A    0.01,=0A =
   0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.pagecac=
he_get_page.simple_write_begin.generic_perform_write.__generic_file_write_i=
ter.generic_file_write_iter": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.module_put.__fput.___=
_fput.task_work_run.do_notify_resume": [=0A    0.01,=0A    0.01,=0A    0.01=
,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.might_fault.sy=
stem_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A  =
  0.01=0A  ],=0A  "perf-profile.cpu-cycles.system_call_fastpath.kill": [=0A=
    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.terminate_walk.path_openat.do_filp_open.do_sys_open.sys_o=
pen": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.02,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.__dentry_kill.dcache_dir_close.__fput.____fpu=
t.task_work_run": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0=
=2E01=0A  ],=0A  "perf-profile.cpu-cycles.dput.path_put.vfs_fstatat.SYSC_ne=
wstat.sys_newstat": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.__d_instantiate.d_instantiate.sim=
ple_lookup.lookup_real.do_last": [=0A    0.01,=0A    0.01,=0A    0.01,=0A  =
  0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.d_lookup.lookup_dcac=
he.__lookup_hash.do_unlinkat.sys_unlink": [=0A    0.01,=0A    0.01,=0A    0=
=2E01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.add_to_pa=
ge_cache_lru.grab_cache_page_write_begin.simple_write_begin.generic_perform=
_write.__generic_file_write_iter": [=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.__zone_watermark_ok.__alloc_pages_nodemask.alloc_pages_current.__p=
age_cache_alloc.pagecache_get_page": [=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.lockref_put_or_=
lock.dput.path_put.user_statfs.SYSC_statfs": [=0A    0.01,=0A    0,=0A    0=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__percpu_counter_add.__sb_=
start_write.vfs_write.sys_pwrite64.system_call_fastpath": [=0A    0.01,=0A =
   0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cy=
cles.call_rcu_sched.__dentry_kill.dput.terminate_walk.path_lookupat": [=0A =
   0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cy=
cles.mntput_no_expire.terminate_walk.path_lookupat.filename_lookup.user_pat=
h_at_empty": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.from_kgid_munged.SYSC_newfstat.sys_new=
fstat.system_call_fastpath.__fxstat64": [=0A    0.01,=0A    0.01,=0A    0.0=
1,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.integrity_iin=
t_find.ima_file_free.__fput.____fput.task_work_run": [=0A    0.01,=0A    0.=
01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.final_putname.user_path_=
at_empty.user_path_at.vfs_fstatat.SYSC_newstat": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.02,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.gra=
b_cache_page_write_begin.generic_perform_write.__generic_file_write_iter.ge=
neric_file_write_iter.new_sync_write": [=0A    0.01,=0A    0.01,=0A    0.01=
,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.unlazy_walk.lo=
okup_fast.do_last.path_openat.do_filp_open": [=0A    0.01=0A  ],=0A  "perf-=
profile.cpu-cycles.__sb_end_write.mnt_drop_write.do_unlinkat.sys_unlink.sys=
tem_call_fastpath": [=0A    0.01,=0A    0,=0A    0,=0A    0,=0A    0.01=0A =
 ],=0A  "perf-profile.cpu-cycles.file_remove_suid.generic_file_write_iter.n=
ew_sync_write.vfs_write.sys_pwrite64": [=0A    0.01,=0A    0,=0A    0.01,=
=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__mod_zone_page=
_state.free_pcppages_bulk.free_hot_cold_page.free_hot_cold_page_list.releas=
e_pages": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  =
],=0A  "perf-profile.cpu-cycles.handle_dots.path_openat.do_filp_open.do_sys=
_open.sys_openat": [=0A    0.01,=0A    0.01,=0A    0,=0A    0.01,=0A    0.0=
1=0A  ],=0A  "perf-profile.cpu-cycles.terminate_walk.path_openat.do_filp_op=
en.do_sys_open.sys_openat": [=0A    0.01,=0A    0.01,=0A    0.02,=0A    0.0=
2,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.SYSC_newfstat.system_call=
_fastpath.__fxstat64": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A=
    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__radix_tree_preload.__add_to_=
page_cache_locked.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_=
write_begin": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.__mutex_init.path_openat.do_filp_open.=
do_sys_open.sys_open": [=0A    0.01,=0A    0,=0A    0.01,=0A    0,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles.__mod_zone_page_state.__pagevec_lru_=
add_fn.pagevec_lru_move_fn.__lru_cache_add.lru_cache_add": [=0A    0.01,=0A=
    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-c=
ycles.d_lookup.__lookup_hash.lookup_slow.path_lookupat.filename_lookup": [=
=0A    0.01,=0A    0,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.__slab_alloc.kmem_cache_alloc.selinux_inode_alloc_security.s=
ecurity_inode_alloc.inode_init_always": [=0A    0.01,=0A    0.01,=0A    0.0=
1,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__d_free.kthr=
ead.ret_from_fork": [=0A    0.01,=0A    0,=0A    0.01,=0A    0,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.page_mapping.wait_for_stable_page.grab=
_cache_page_write_begin.simple_write_begin.generic_perform_write": [=0A    =
0.01,=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.mem_cgroup_try_charge_mm.__add_to_page_cache_locked.add_to_page_=
cache_lru.pagecache_get_page.grab_cache_page_write_begin": [=0A    0.01,=0A=
    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-c=
ycles.__dec_zone_page_state.__delete_from_page_cache.delete_from_page_cache=
=2Etruncate_inode_page.truncate_inode_pages_range": [=0A    0.01=0A  ],=0A =
 "perf-profile.cpu-cycles.put_unused_fd.sys_open.system_call_fastpath.open6=
4": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A =
 "perf-profile.cpu-cycles.__add_to_page_cache_locked.pagecache_get_page.gra=
b_cache_page_write_begin.simple_write_begin.generic_perform_write": [=0A   =
 0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycl=
es.ima_match_policy.process_measurement.ima_file_check.do_last.path_openat"=
: [=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__dentry_kil=
l.terminate_walk.path_lookupat.filename_lookup.user_path_at_empty": [=0A   =
 0.01,=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.getname_flags.do_sys_open.sys_openat.system_call_fastpath": [=
=0A    0.01,=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.mutex_lock.do_last.path_openat.do_filp_open.do_sys_open":=
 [=0A    0.01,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cy=
cles.update_curr.task_tick_fair.scheduler_tick.update_process_times.tick_sc=
hed_handle": [=0A    0.01,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=
=0A  "perf-profile.cpu-cycles.lookup_page_cgroup.mem_cgroup_charge_file.__a=
dd_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page": [=0A    =
0.01,=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycle=
s.path_openat.do_sys_open.sys_open.system_call_fastpath.open64": [=0A    0.=
01,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__m=
nt_want_write.mnt_want_write.SYSC_renameat2.sys_rename.system_call_fastpath=
": [=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles=
=2Elookup_real.__lookup_hash.lookup_slow.path_lookupat.filename_lookup": [=
=0A    0.01,=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.d_flags_for_inode.__d_instantiate.d_instantiate.ramfs_mkn=
od.ramfs_create": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0=
=2E01=0A  ],=0A  "perf-profile.cpu-cycles.lookup_dcache.lookup_slow.path_lo=
okupat.filename_lookup.user_path_at_empty": [=0A    0.01,=0A    0,=0A    0,=
=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.release_pages.page=
vec_lru_move_fn.lru_add_drain_cpu.__pagevec_release.truncate_inode_pages_ra=
nge": [=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_getatt=
r.vfs_getattr.vfs_fstatat.SYSC_newstat.sys_newstat": [=0A    0.01=0A  ],=0A=
  "perf-profile.cpu-cycles.final_putname.putname.do_sys_open.sys_openat.sys=
tem_call_fastpath": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.terminate_walk.filename_lookup.us=
er_path_at_empty.user_path_at.vfs_fstatat": [=0A    0.01,=0A    0.01,=0A   =
 0.02,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.simple_lo=
okup.do_last.path_openat.do_filp_open.do_sys_open": [=0A    0.01=0A  ],=0A =
 "perf-profile.cpu-cycles.may_open.path_openat.do_filp_open.do_sys_open.sys=
_open": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A=
  "perf-profile.cpu-cycles.open_check_o_direct.path_openat.do_filp_open.do_=
sys_open.sys_openat": [=0A    0.01,=0A    0.01,=0A    0,=0A    0.02,=0A    =
0.01=0A  ],=0A  "perf-profile.cpu-cycles.call_rcu_sched.____fput.task_work_=
run.do_notify_resume.int_signal": [=0A    0.01,=0A    0,=0A    0.01,=0A    =
0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_getattr.=
vfs_getattr.vfs_fstat.SYSC_newfstat.sys_newfstat": [=0A    0.01=0A  ],=0A  =
"perf-profile.cpu-cycles.rename": [=0A    0.01,=0A    0,=0A    0.01,=0A    =
0.01=0A  ],=0A  "perf-profile.cpu-cycles.fsync": [=0A    0.01,=0A    0,=0A =
   0.01=0A  ],=0A  "perf-profile.cpu-cycles.int_signal.close": [=0A    0.01=
,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.c=
pu-cycles.open@plt": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A  =
  0.01=0A  ],=0A  "perf-profile.cpu-cycles.strrchr@plt": [=0A    0.01,=0A  =
  0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cyc=
les.int_check_syscall_exit_work.close": [=0A    0.01,=0A    0.01,=0A    0.0=
1,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.free@plt": [=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "per=
f-profile.cpu-cycles.memmove@plt": [=0A    0.01,=0A    0.01,=0A    0.01,=0A=
    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.inode_has_buffers.=
destroy_inode.evict.iput.do_unlinkat": [=0A    0.01,=0A    0.01,=0A    0.01=
,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.current_umask.=
path_openat.do_filp_open.do_sys_open.sys_open": [=0A    0.01,=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.@pl=
t": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "p=
erf-profile.cpu-cycles._IO_file_underflow": [=0A    0.01,=0A    0.01,=0A   =
 0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.utime": [=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "per=
f-profile.cpu-cycles.generic_delete_inode.do_unlinkat.sys_unlink.system_cal=
l_fastpath.unlink": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.closedir@plt": [=0A    0.01,=0A  =
  0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cyc=
les.__fdget_raw.SYSC_newfstat.sys_newfstat.system_call_fastpath.__fxstat64"=
: [=0A    0.01,=0A    0.02,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.port_inb.kcs_event.smi_event_handler.ipmi_thread.kthread": [=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.selinux_inode_create.vfs_create.d=
o_last.path_openat.do_filp_open": [=0A    0.01=0A  ],=0A  "perf-profile.cpu=
-cycles.strtol@plt": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A  =
  0.01=0A  ],=0A  "perf-profile.cpu-cycles.memcpy.mga_imageblit.soft_cursor=
=2Ebit_cursor.fb_flashcursor": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    =
0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__uflow": [=0A    0.01=
,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.02=0A  ],=0A  "perf-profile.c=
pu-cycles.__errno_location": [=0A    0.01,=0A    0.02,=0A    0.01,=0A    0.=
01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.kmalloc_slab.kstrdup.vfs=
_rename.SYSC_renameat2.sys_rename": [=0A    0.01,=0A    0.01,=0A    0.01,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.read": [=0A    0.01,=0A    =
0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycle=
s.__statfs": [=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles._IO_switch_to_get_mode": [=0A    0.01,=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "cpuidle.POLL.ti=
me": [=0A    1092,=0A    343,=0A    37,=0A    476,=0A    794=0A  ],=0A  "cp=
uidle.POLL.usage": [=0A    98,=0A    29,=0A    4,=0A    37,=0A    63=0A  ],=
=0A  "cpuidle.C1-IVT.time": [=0A    267104883,=0A    120873646,=0A    34160=
642,=0A    139151084,=0A    242384896=0A  ],=0A  "cpuidle.C1-IVT.usage": [=
=0A    1360591,=0A    543028,=0A    130163,=0A    672663,=0A    1199119=0A =
 ],=0A  "cpuidle.C1E-IVT.time": [=0A    66107711,=0A    30739148,=0A    729=
0392,=0A    34676524,=0A    56891267=0A  ],=0A  "cpuidle.C1E-IVT.usage": [=
=0A    220943,=0A    95575,=0A    21060,=0A    114397,=0A    188080=0A  ],=
=0A  "cpuidle.C3-IVT.time": [=0A    10623047,=0A    4377867,=0A    977566,=
=0A    5443549,=0A    8843930=0A  ],=0A  "cpuidle.C3-IVT.usage": [=0A    35=
567,=0A    14074,=0A    3760,=0A    17080,=0A    30878=0A  ],=0A  "cpuidle.=
C6-IVT.time": [=0A    491885724,=0A    298071114,=0A    130912197,=0A    31=
6192356,=0A    480734982=0A  ],=0A  "cpuidle.C6-IVT.usage": [=0A    689576,=
=0A    324314,=0A    90527,=0A    378797,=0A    661523=0A  ],=0A  "energy.e=
nergy-cores": [=0A    4.065612260049534e-08,=0A    4.071212349768007e-08,=
=0A    4.087103554642946e-08,=0A    4.079228448856192e-08,=0A    4.07292522=
1526595e-08=0A  ],=0A  "energy.energy-pkg": [=0A    4.888768140973666e-08,=
=0A    4.895419570521717e-08,=0A    4.909615892103379e-08,=0A    4.90485052=
4399446e-08,=0A    4.898206607504862e-08=0A  ],=0A  "energy.energy-ram": [=
=0A    4.181817180263982e-09,=0A    4.2774299544809935e-09,=0A    4.2838068=
420478075e-09,=0A    4.235888341384051e-09,=0A    4.21308095837406e-09=0A  =
],=0A  "dbench.throughput-MB/sec": [=0A    25517.5,=0A    25516.4,=0A    25=
929.2,=0A    25818.7,=0A    25680.8=0A  ],=0A  "dbench.clients": [=0A    48=
,=0A    48,=0A    48,=0A    48,=0A    48=0A  ],=0A  "dbench.procs": [=0A   =
 48,=0A    48,=0A    48,=0A    48,=0A    48=0A  ],=0A  "dbench.max_latency"=
: [=0A    82.08,=0A    58.332,=0A    36.066,=0A    56.588,=0A    79.394=0A =
 ],=0A  "turbostat.%c0": [=0A    97.59,=0A    98.69,=0A    99.5,=0A    98.5=
8,=0A    97.73=0A  ],=0A  "turbostat.GHz": [=0A    2.99,=0A    2.99,=0A    =
2.99,=0A    2.99,=0A    2.99=0A  ],=0A  "turbostat.TSC": [=0A    2.69,=0A  =
  2.69,=0A    2.69,=0A    2.69,=0A    2.69=0A  ],=0A  "turbostat.%c1": [=0A=
    2.26,=0A    1.18,=0A    0.39,=0A    1.29,=0A    2.13=0A  ],=0A  "turbos=
tat.%c6": [=0A    0.15,=0A    0.12,=0A    0.11,=0A    0.13,=0A    0.14=0A  =
],=0A  "turbostat.CTMP": [=0A    69,=0A    69,=0A    68,=0A    69,=0A    70=
=0A  ],=0A  "turbostat.PTMP": [=0A    70,=0A    69,=0A    68,=0A    69,=0A =
   70=0A  ],=0A  "turbostat.%pc2": [=0A    0.02,=0A    0.03,=0A    0.03,=0A=
    0.02=0A  ],=0A  "turbostat.%pc6": [=0A    0.04,=0A    0,=0A    0,=0A   =
 0.03=0A  ],=0A  "turbostat.Pkg_W": [=0A    212.56,=0A    212.85,=0A    213=
=2E47,=0A    213.26,=0A    212.97=0A  ],=0A  "turbostat.Cor_W": [=0A    176=
=2E77,=0A    177.01,=0A    177.7,=0A    177.36,=0A    177.09=0A  ],=0A  "tu=
rbostat.RAM_W": [=0A    18.18,=0A    18.6,=0A    18.63,=0A    18.42,=0A    =
18.32=0A  ],=0A  "interrupts.CPU0.0:IO-APIC-edge.timer": [=0A    0,=0A    0=
,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.0:IO-APIC-edge.timer": [=
=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.4:=
IO-APIC-edge.serial": [=0A    35,=0A    35,=0A    35,=0A    35,=0A    35=0A=
  ],=0A  "interrupts.4:IO-APIC-edge.serial": [=0A    35,=0A    35,=0A    35=
,=0A    35,=0A    35=0A  ],=0A  "interrupts.CPU0.8:IO-APIC-edge.rtc0": [=0A=
    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.8:IO-APIC-=
edge.rtc0": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "inter=
rupts.CPU0.20:IO-APIC-fasteoi.ehci_hcd:usb2": [=0A    0,=0A    0,=0A    0,=
=0A    0,=0A    0=0A  ],=0A  "interrupts.20:IO-APIC-fasteoi.ehci_hcd:usb2":=
 [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.=
22:IO-APIC-fasteoi.ehci_hcd:usb1": [=0A    0,=0A    0,=0A    0,=0A    0,=0A=
    0=0A  ],=0A  "interrupts.22:IO-APIC-fasteoi.ehci_hcd:usb1": [=0A    0,=
=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.96:PCI-MSI-=
edge.eth0": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "inter=
rupts.96:PCI-MSI-edge.eth0": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=
=0A  ],=0A  "interrupts.CPU0.97:PCI-MSI-edge.eth0-TxRx-0": [=0A    2196,=0A=
    2646,=0A    2301,=0A    2674,=0A    2149=0A  ],=0A  "interrupts.97:PCI-=
MSI-edge.eth0-TxRx-0": [=0A    2196,=0A    2646,=0A    2301,=0A    2674,=0A=
    2149=0A  ],=0A  "interrupts.CPU0.98:PCI-MSI-edge.eth0-TxRx-1": [=0A    =
374,=0A    368,=0A    368,=0A    369,=0A    456=0A  ],=0A  "interrupts.98:P=
CI-MSI-edge.eth0-TxRx-1": [=0A    374,=0A    368,=0A    368,=0A    369,=0A =
   456=0A  ],=0A  "interrupts.CPU0.99:PCI-MSI-edge.eth0-TxRx-2": [=0A    60=
2,=0A    586,=0A    594,=0A    549,=0A    476=0A  ],=0A  "interrupts.99:PCI=
-MSI-edge.eth0-TxRx-2": [=0A    602,=0A    586,=0A    594,=0A    549,=0A   =
 476=0A  ],=0A  "interrupts.CPU0.100:PCI-MSI-edge.eth0-TxRx-3": [=0A    389=
,=0A    501,=0A    372,=0A    507,=0A    380=0A  ],=0A  "interrupts.100:PCI=
-MSI-edge.eth0-TxRx-3": [=0A    389,=0A    501,=0A    372,=0A    507,=0A   =
 380=0A  ],=0A  "interrupts.CPU0.101:PCI-MSI-edge.eth0-TxRx-4": [=0A    462=
,=0A    428,=0A    442,=0A    529,=0A    538=0A  ],=0A  "interrupts.101:PCI=
-MSI-edge.eth0-TxRx-4": [=0A    462,=0A    428,=0A    442,=0A    529,=0A   =
 538=0A  ],=0A  "interrupts.CPU0.102:PCI-MSI-edge.eth0-TxRx-5": [=0A    507=
,=0A    366,=0A    365,=0A    366,=0A    371=0A  ],=0A  "interrupts.102:PCI=
-MSI-edge.eth0-TxRx-5": [=0A    507,=0A    366,=0A    365,=0A    366,=0A   =
 371=0A  ],=0A  "interrupts.CPU0.103:PCI-MSI-edge.eth0-TxRx-6": [=0A    462=
,=0A    363,=0A    366,=0A    364,=0A    364=0A  ],=0A  "interrupts.103:PCI=
-MSI-edge.eth0-TxRx-6": [=0A    462,=0A    363,=0A    366,=0A    364,=0A   =
 364=0A  ],=0A  "interrupts.CPU0.104:PCI-MSI-edge.eth0-TxRx-7": [=0A    384=
,=0A    371,=0A    373,=0A    372,=0A    374=0A  ],=0A  "interrupts.104:PCI=
-MSI-edge.eth0-TxRx-7": [=0A    384,=0A    371,=0A    373,=0A    372,=0A   =
 374=0A  ],=0A  "interrupts.CPU0.106:PCI-MSI-edge": [=0A    0,=0A    0,=0A =
   0,=0A    0,=0A    0=0A  ],=0A  "interrupts.106:PCI-MSI-edge": [=0A    0,=
=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.107:PCI-MSI=
-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupt=
s.107:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=
=0A  "interrupts.CPU0.108:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A   =
 0,=0A    0=0A  ],=0A  "interrupts.108:PCI-MSI-edge": [=0A    0,=0A    0,=
=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.109:PCI-MSI-edge": [=
=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.109:PCI=
-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "inter=
rupts.CPU0.110:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=
=0A  ],=0A  "interrupts.110:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A =
   0,=0A    0=0A  ],=0A  "interrupts.CPU0.111:PCI-MSI-edge": [=0A    0,=0A =
   0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.111:PCI-MSI-edge": [=
=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.11=
2:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "=
interrupts.112:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=
=0A  ],=0A  "interrupts.CPU0.113:PCI-MSI-edge": [=0A    0,=0A    0,=0A    0=
,=0A    0,=0A    0=0A  ],=0A  "interrupts.113:PCI-MSI-edge": [=0A    0,=0A =
   0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.CPU0.NMI:Non-maskabl=
e_interrupts": [=0A    39160,=0A    39917,=0A    39782,=0A    39746,=0A    =
39370=0A  ],=0A  "interrupts.CPU1.NMI:Non-maskable_interrupts": [=0A    396=
79,=0A    39570,=0A    39794,=0A    39802,=0A    39822=0A  ],=0A  "interrup=
ts.CPU2.NMI:Non-maskable_interrupts": [=0A    39728,=0A    39959,=0A    398=
51,=0A    39790,=0A    39678=0A  ],=0A  "interrupts.CPU3.NMI:Non-maskable_i=
nterrupts": [=0A    39333,=0A    39885,=0A    39992,=0A    39693,=0A    394=
18=0A  ],=0A  "interrupts.CPU4.NMI:Non-maskable_interrupts": [=0A    39285,=
=0A    39601,=0A    39779,=0A    39871,=0A    39720=0A  ],=0A  "interrupts.=
CPU5.NMI:Non-maskable_interrupts": [=0A    39106,=0A    39970,=0A    40007,=
=0A    39767,=0A    39710=0A  ],=0A  "interrupts.CPU6.NMI:Non-maskable_inte=
rrupts": [=0A    39635,=0A    39904,=0A    39427,=0A    39663,=0A    39526=
=0A  ],=0A  "interrupts.CPU7.NMI:Non-maskable_interrupts": [=0A    39284,=
=0A    39844,=0A    39715,=0A    39945,=0A    39640=0A  ],=0A  "interrupts.=
CPU8.NMI:Non-maskable_interrupts": [=0A    39519,=0A    39470,=0A    40008,=
=0A    39724,=0A    39247=0A  ],=0A  "interrupts.CPU9.NMI:Non-maskable_inte=
rrupts": [=0A    39302,=0A    39562,=0A    39850,=0A    39935,=0A    39596=
=0A  ],=0A  "interrupts.CPU10.NMI:Non-maskable_interrupts": [=0A    38757,=
=0A    39247,=0A    39998,=0A    39724,=0A    39473=0A  ],=0A  "interrupts.=
CPU11.NMI:Non-maskable_interrupts": [=0A    39504,=0A    38941,=0A    39704=
,=0A    39969,=0A    39615=0A  ],=0A  "interrupts.CPU12.NMI:Non-maskable_in=
terrupts": [=0A    38134,=0A    39938,=0A    39855,=0A    39571,=0A    3900=
3=0A  ],=0A  "interrupts.CPU13.NMI:Non-maskable_interrupts": [=0A    39198,=
=0A    39732,=0A    39909,=0A    38906,=0A    38991=0A  ],=0A  "interrupts.=
CPU14.NMI:Non-maskable_interrupts": [=0A    38272,=0A    39699,=0A    39977=
,=0A    38536,=0A    37598=0A  ],=0A  "interrupts.CPU15.NMI:Non-maskable_in=
terrupts": [=0A    38738,=0A    39605,=0A    39972,=0A    39265,=0A    3826=
7=0A  ],=0A  "interrupts.CPU16.NMI:Non-maskable_interrupts": [=0A    37679,=
=0A    39755,=0A    39814,=0A    38614,=0A    39414=0A  ],=0A  "interrupts.=
CPU17.NMI:Non-maskable_interrupts": [=0A    38877,=0A    39900,=0A    39384=
,=0A    39061,=0A    38838=0A  ],=0A  "interrupts.CPU18.NMI:Non-maskable_in=
terrupts": [=0A    38444,=0A    39669,=0A    39924,=0A    38137,=0A    3836=
4=0A  ],=0A  "interrupts.CPU19.NMI:Non-maskable_interrupts": [=0A    39371,=
=0A    39723,=0A    39973,=0A    38915,=0A    38754=0A  ],=0A  "interrupts.=
CPU20.NMI:Non-maskable_interrupts": [=0A    38859,=0A    39768,=0A    39828=
,=0A    38823,=0A    39476=0A  ],=0A  "interrupts.CPU21.NMI:Non-maskable_in=
terrupts": [=0A    38384,=0A    39687,=0A    39820,=0A    38690,=0A    3879=
4=0A  ],=0A  "interrupts.CPU22.NMI:Non-maskable_interrupts": [=0A    39062,=
=0A    39427,=0A    39798,=0A    38130,=0A    38944=0A  ],=0A  "interrupts.=
CPU23.NMI:Non-maskable_interrupts": [=0A    38352,=0A    39682,=0A    39934=
,=0A    38810,=0A    39222=0A  ],=0A  "interrupts.CPU24.NMI:Non-maskable_in=
terrupts": [=0A    39344,=0A    39627,=0A    40008,=0A    39547,=0A    3937=
5=0A  ],=0A  "interrupts.CPU25.NMI:Non-maskable_interrupts": [=0A    39186,=
=0A    39832,=0A    40001,=0A    39548,=0A    39581=0A  ],=0A  "interrupts.=
CPU26.NMI:Non-maskable_interrupts": [=0A    39123,=0A    39794,=0A    40008=
,=0A    39614,=0A    39446=0A  ],=0A  "interrupts.CPU27.NMI:Non-maskable_in=
terrupts": [=0A    39000,=0A    39799,=0A    39967,=0A    39850,=0A    3975=
9=0A  ],=0A  "interrupts.CPU28.NMI:Non-maskable_interrupts": [=0A    39409,=
=0A    39960,=0A    40006,=0A    39313,=0A    39032=0A  ],=0A  "interrupts.=
CPU29.NMI:Non-maskable_interrupts": [=0A    38979,=0A    39260,=0A    39903=
,=0A    39988,=0A    39801=0A  ],=0A  "interrupts.CPU30.NMI:Non-maskable_in=
terrupts": [=0A    39300,=0A    39970,=0A    39598,=0A    39628,=0A    3938=
4=0A  ],=0A  "interrupts.CPU31.NMI:Non-maskable_interrupts": [=0A    39608,=
=0A    39869,=0A    40007,=0A    38982,=0A    39513=0A  ],=0A  "interrupts.=
CPU32.NMI:Non-maskable_interrupts": [=0A    39485,=0A    39847,=0A    39823=
,=0A    39788,=0A    39643=0A  ],=0A  "interrupts.CPU33.NMI:Non-maskable_in=
terrupts": [=0A    39296,=0A    39537,=0A    39934,=0A    39837,=0A    3921=
1=0A  ],=0A  "interrupts.CPU34.NMI:Non-maskable_interrupts": [=0A    38843,=
=0A    39928,=0A    40007,=0A    39852,=0A    39041=0A  ],=0A  "interrupts.=
CPU35.NMI:Non-maskable_interrupts": [=0A    39450,=0A    39906,=0A    40003=
,=0A    39816,=0A    39760=0A  ],=0A  "interrupts.CPU36.NMI:Non-maskable_in=
terrupts": [=0A    38792,=0A    39664,=0A    39759,=0A    38692,=0A    3884=
8=0A  ],=0A  "interrupts.CPU37.NMI:Non-maskable_interrupts": [=0A    38371,=
=0A    39985,=0A    39968,=0A    39275,=0A    38732=0A  ],=0A  "interrupts.=
CPU38.NMI:Non-maskable_interrupts": [=0A    38056,=0A    39783,=0A    39940=
,=0A    37537,=0A    38757=0A  ],=0A  "interrupts.CPU39.NMI:Non-maskable_in=
terrupts": [=0A    38354,=0A    39877,=0A    39942,=0A    39015,=0A    3923=
4=0A  ],=0A  "interrupts.CPU40.NMI:Non-maskable_interrupts": [=0A    38823,=
=0A    39872,=0A    39845,=0A    39152,=0A    38222=0A  ],=0A  "interrupts.=
CPU41.NMI:Non-maskable_interrupts": [=0A    39222,=0A    39461,=0A    39952=
,=0A    38300,=0A    38122=0A  ],=0A  "interrupts.CPU42.NMI:Non-maskable_in=
terrupts": [=0A    38459,=0A    39466,=0A    39799,=0A    38644,=0A    3924=
6=0A  ],=0A  "interrupts.CPU43.NMI:Non-maskable_interrupts": [=0A    38650,=
=0A    39806,=0A    39883,=0A    39144,=0A    37880=0A  ],=0A  "interrupts.=
CPU44.NMI:Non-maskable_interrupts": [=0A    36587,=0A    39941,=0A    39942=
,=0A    38953,=0A    37964=0A  ],=0A  "interrupts.CPU45.NMI:Non-maskable_in=
terrupts": [=0A    39600,=0A    39024,=0A    39939,=0A    38575,=0A    3832=
8=0A  ],=0A  "interrupts.CPU46.NMI:Non-maskable_interrupts": [=0A    39240,=
=0A    39963,=0A    39872,=0A    38928,=0A    39125=0A  ],=0A  "interrupts.=
CPU47.NMI:Non-maskable_interrupts": [=0A    39244,=0A    39454,=0A    39867=
,=0A    37694,=0A    38368=0A  ],=0A  "interrupts.NMI:Non-maskable_interrup=
ts": [=0A    1870083,=0A    1906080,=0A    1914068,=0A    1882759,=0A    18=
76852=0A  ],=0A  "interrupts.CPU0.LOC:Local_timer_interrupts": [=0A    7136=
13,=0A    717043,=0A    718374,=0A    715998,=0A    713067=0A  ],=0A  "inte=
rrupts.CPU1.LOC:Local_timer_interrupts": [=0A    711043,=0A    715517,=0A  =
  718163,=0A    714875,=0A    713332=0A  ],=0A  "interrupts.CPU2.LOC:Local_=
timer_interrupts": [=0A    712334,=0A    716224,=0A    718063,=0A    715255=
,=0A    711003=0A  ],=0A  "interrupts.CPU3.LOC:Local_timer_interrupts": [=
=0A    710971,=0A    715996,=0A    718514,=0A    715633,=0A    712859=0A  ]=
,=0A  "interrupts.CPU4.LOC:Local_timer_interrupts": [=0A    710662,=0A    7=
15420,=0A    717371,=0A    715405,=0A    712519=0A  ],=0A  "interrupts.CPU5=
=2ELOC:Local_timer_interrupts": [=0A    710979,=0A    715802,=0A    718562,=
=0A    714508,=0A    712414=0A  ],=0A  "interrupts.CPU6.LOC:Local_timer_int=
errupts": [=0A    711366,=0A    716065,=0A    718136,=0A    714517,=0A    7=
11944=0A  ],=0A  "interrupts.CPU7.LOC:Local_timer_interrupts": [=0A    7105=
59,=0A    714896,=0A    718646,=0A    715357,=0A    711663=0A  ],=0A  "inte=
rrupts.CPU8.LOC:Local_timer_interrupts": [=0A    711248,=0A    715342,=0A  =
  718395,=0A    714636,=0A    712376=0A  ],=0A  "interrupts.CPU9.LOC:Local_=
timer_interrupts": [=0A    710089,=0A    715747,=0A    718351,=0A    714522=
,=0A    711596=0A  ],=0A  "interrupts.CPU10.LOC:Local_timer_interrupts": [=
=0A    710523,=0A    713803,=0A    718465,=0A    715339,=0A    712444=0A  ]=
,=0A  "interrupts.CPU11.LOC:Local_timer_interrupts": [=0A    710074,=0A    =
715195,=0A    718099,=0A    715083,=0A    711917=0A  ],=0A  "interrupts.CPU=
12.LOC:Local_timer_interrupts": [=0A    702807,=0A    710200,=0A    718166,=
=0A    710934,=0A    702222=0A  ],=0A  "interrupts.CPU13.LOC:Local_timer_in=
terrupts": [=0A    701615,=0A    709196,=0A    717283,=0A    709755,=0A    =
703782=0A  ],=0A  "interrupts.CPU14.LOC:Local_timer_interrupts": [=0A    70=
0972,=0A    708041,=0A    717848,=0A    708380,=0A    702896=0A  ],=0A  "in=
terrupts.CPU15.LOC:Local_timer_interrupts": [=0A    700818,=0A    709729,=
=0A    716842,=0A    708561,=0A    700794=0A  ],=0A  "interrupts.CPU16.LOC:=
Local_timer_interrupts": [=0A    701400,=0A    708452,=0A    717878,=0A    =
707752,=0A    701199=0A  ],=0A  "interrupts.CPU17.LOC:Local_timer_interrupt=
s": [=0A    698619,=0A    709874,=0A    717822,=0A    708635,=0A    701936=
=0A  ],=0A  "interrupts.CPU18.LOC:Local_timer_interrupts": [=0A    699108,=
=0A    707507,=0A    716743,=0A    710356,=0A    701099=0A  ],=0A  "interru=
pts.CPU19.LOC:Local_timer_interrupts": [=0A    698808,=0A    707138,=0A    =
716600,=0A    708408,=0A    700986=0A  ],=0A  "interrupts.CPU20.LOC:Local_t=
imer_interrupts": [=0A    699236,=0A    708973,=0A    716789,=0A    707902,=
=0A    701208=0A  ],=0A  "interrupts.CPU21.LOC:Local_timer_interrupts": [=
=0A    698190,=0A    708168,=0A    717272,=0A    708195,=0A    700170=0A  ]=
,=0A  "interrupts.CPU22.LOC:Local_timer_interrupts": [=0A    699871,=0A    =
707709,=0A    716712,=0A    708359,=0A    698361=0A  ],=0A  "interrupts.CPU=
23.LOC:Local_timer_interrupts": [=0A    700657,=0A    707058,=0A    716430,=
=0A    707720,=0A    698780=0A  ],=0A  "interrupts.CPU24.LOC:Local_timer_in=
terrupts": [=0A    708630,=0A    715670,=0A    718751,=0A    714059,=0A    =
711199=0A  ],=0A  "interrupts.CPU25.LOC:Local_timer_interrupts": [=0A    70=
9151,=0A    716134,=0A    718636,=0A    714499,=0A    710335=0A  ],=0A  "in=
terrupts.CPU26.LOC:Local_timer_interrupts": [=0A    709433,=0A    714909,=
=0A    718223,=0A    714879,=0A    712087=0A  ],=0A  "interrupts.CPU27.LOC:=
Local_timer_interrupts": [=0A    709144,=0A    715672,=0A    718978,=0A    =
714525,=0A    710553=0A  ],=0A  "interrupts.CPU28.LOC:Local_timer_interrupt=
s": [=0A    709897,=0A    715771,=0A    719224,=0A    714480,=0A    712187=
=0A  ],=0A  "interrupts.CPU29.LOC:Local_timer_interrupts": [=0A    709863,=
=0A    715199,=0A    717399,=0A    715120,=0A    711402=0A  ],=0A  "interru=
pts.CPU30.LOC:Local_timer_interrupts": [=0A    709386,=0A    715083,=0A    =
717739,=0A    714594,=0A    711757=0A  ],=0A  "interrupts.CPU31.LOC:Local_t=
imer_interrupts": [=0A    710056,=0A    715943,=0A    718887,=0A    714199,=
=0A    711447=0A  ],=0A  "interrupts.CPU32.LOC:Local_timer_interrupts": [=
=0A    708536,=0A    715371,=0A    719001,=0A    714710,=0A    711599=0A  ]=
,=0A  "interrupts.CPU33.LOC:Local_timer_interrupts": [=0A    709600,=0A    =
715095,=0A    717447,=0A    714300,=0A    711566=0A  ],=0A  "interrupts.CPU=
34.LOC:Local_timer_interrupts": [=0A    708822,=0A    716096,=0A    717813,=
=0A    713767,=0A    710275=0A  ],=0A  "interrupts.CPU35.LOC:Local_timer_in=
terrupts": [=0A    709564,=0A    716220,=0A    717264,=0A    714148,=0A    =
711136=0A  ],=0A  "interrupts.CPU36.LOC:Local_timer_interrupts": [=0A    69=
7751,=0A    709083,=0A    716411,=0A    707743,=0A    698244=0A  ],=0A  "in=
terrupts.CPU37.LOC:Local_timer_interrupts": [=0A    699878,=0A    709178,=
=0A    717861,=0A    705750,=0A    694176=0A  ],=0A  "interrupts.CPU38.LOC:=
Local_timer_interrupts": [=0A    697167,=0A    707497,=0A    716585,=0A    =
706915,=0A    700866=0A  ],=0A  "interrupts.CPU39.LOC:Local_timer_interrupt=
s": [=0A    699357,=0A    706783,=0A    716382,=0A    706987,=0A    700819=
=0A  ],=0A  "interrupts.CPU40.LOC:Local_timer_interrupts": [=0A    694732,=
=0A    708920,=0A    716575,=0A    706760,=0A    699197=0A  ],=0A  "interru=
pts.CPU41.LOC:Local_timer_interrupts": [=0A    698287,=0A    706037,=0A    =
715939,=0A    706234,=0A    696905=0A  ],=0A  "interrupts.CPU42.LOC:Local_t=
imer_interrupts": [=0A    696308,=0A    709131,=0A    716983,=0A    706740,=
=0A    697333=0A  ],=0A  "interrupts.CPU43.LOC:Local_timer_interrupts": [=
=0A    695460,=0A    710312,=0A    717323,=0A    706294,=0A    698989=0A  ]=
,=0A  "interrupts.CPU44.LOC:Local_timer_interrupts": [=0A    695059,=0A    =
707593,=0A    717134,=0A    703986,=0A    696307=0A  ],=0A  "interrupts.CPU=
45.LOC:Local_timer_interrupts": [=0A    696035,=0A    708697,=0A    716821,=
=0A    706610,=0A    697110=0A  ],=0A  "interrupts.CPU46.LOC:Local_timer_in=
terrupts": [=0A    693598,=0A    707511,=0A    716428,=0A    708140,=0A    =
699580=0A  ],=0A  "interrupts.CPU47.LOC:Local_timer_interrupts": [=0A    69=
5738,=0A    708778,=0A    716420,=0A    706688,=0A    698188=0A  ],=0A  "in=
terrupts.LOC:Local_timer_interrupts": [=0A    33807014,=0A    34175778,=0A =
   34445748,=0A    34138212,=0A    33873824=0A  ],=0A  "interrupts.CPU0.PMI=
:Performance_monitoring_interrupts": [=0A    39160,=0A    39917,=0A    3978=
2,=0A    39746,=0A    39370=0A  ],=0A  "interrupts.CPU1.PMI:Performance_mon=
itoring_interrupts": [=0A    39679,=0A    39570,=0A    39794,=0A    39802,=
=0A    39822=0A  ],=0A  "interrupts.CPU2.PMI:Performance_monitoring_interru=
pts": [=0A    39728,=0A    39959,=0A    39851,=0A    39790,=0A    39678=0A =
 ],=0A  "interrupts.CPU3.PMI:Performance_monitoring_interrupts": [=0A    39=
333,=0A    39885,=0A    39992,=0A    39693,=0A    39418=0A  ],=0A  "interru=
pts.CPU4.PMI:Performance_monitoring_interrupts": [=0A    39285,=0A    39601=
,=0A    39779,=0A    39871,=0A    39720=0A  ],=0A  "interrupts.CPU5.PMI:Per=
formance_monitoring_interrupts": [=0A    39106,=0A    39970,=0A    40007,=
=0A    39767,=0A    39710=0A  ],=0A  "interrupts.CPU6.PMI:Performance_monit=
oring_interrupts": [=0A    39635,=0A    39904,=0A    39427,=0A    39663,=0A=
    39526=0A  ],=0A  "interrupts.CPU7.PMI:Performance_monitoring_interrupts=
": [=0A    39284,=0A    39844,=0A    39715,=0A    39945,=0A    39640=0A  ],=
=0A  "interrupts.CPU8.PMI:Performance_monitoring_interrupts": [=0A    39519=
,=0A    39470,=0A    40008,=0A    39724,=0A    39247=0A  ],=0A  "interrupts=
=2ECPU9.PMI:Performance_monitoring_interrupts": [=0A    39302,=0A    39562,=
=0A    39850,=0A    39935,=0A    39596=0A  ],=0A  "interrupts.CPU10.PMI:Per=
formance_monitoring_interrupts": [=0A    38757,=0A    39247,=0A    39998,=
=0A    39724,=0A    39473=0A  ],=0A  "interrupts.CPU11.PMI:Performance_moni=
toring_interrupts": [=0A    39504,=0A    38941,=0A    39704,=0A    39969,=
=0A    39615=0A  ],=0A  "interrupts.CPU12.PMI:Performance_monitoring_interr=
upts": [=0A    38134,=0A    39938,=0A    39855,=0A    39571,=0A    39003=0A=
  ],=0A  "interrupts.CPU13.PMI:Performance_monitoring_interrupts": [=0A    =
39198,=0A    39732,=0A    39909,=0A    38906,=0A    38991=0A  ],=0A  "inter=
rupts.CPU14.PMI:Performance_monitoring_interrupts": [=0A    38272,=0A    39=
699,=0A    39977,=0A    38536,=0A    37598=0A  ],=0A  "interrupts.CPU15.PMI=
:Performance_monitoring_interrupts": [=0A    38738,=0A    39605,=0A    3997=
2,=0A    39265,=0A    38267=0A  ],=0A  "interrupts.CPU16.PMI:Performance_mo=
nitoring_interrupts": [=0A    37679,=0A    39755,=0A    39814,=0A    38614,=
=0A    39414=0A  ],=0A  "interrupts.CPU17.PMI:Performance_monitoring_interr=
upts": [=0A    38877,=0A    39900,=0A    39384,=0A    39061,=0A    38838=0A=
  ],=0A  "interrupts.CPU18.PMI:Performance_monitoring_interrupts": [=0A    =
38444,=0A    39669,=0A    39924,=0A    38137,=0A    38364=0A  ],=0A  "inter=
rupts.CPU19.PMI:Performance_monitoring_interrupts": [=0A    39371,=0A    39=
723,=0A    39973,=0A    38915,=0A    38754=0A  ],=0A  "interrupts.CPU20.PMI=
:Performance_monitoring_interrupts": [=0A    38859,=0A    39768,=0A    3982=
8,=0A    38823,=0A    39476=0A  ],=0A  "interrupts.CPU21.PMI:Performance_mo=
nitoring_interrupts": [=0A    38384,=0A    39687,=0A    39820,=0A    38690,=
=0A    38794=0A  ],=0A  "interrupts.CPU22.PMI:Performance_monitoring_interr=
upts": [=0A    39062,=0A    39427,=0A    39798,=0A    38130,=0A    38944=0A=
  ],=0A  "interrupts.CPU23.PMI:Performance_monitoring_interrupts": [=0A    =
38352,=0A    39682,=0A    39934,=0A    38810,=0A    39222=0A  ],=0A  "inter=
rupts.CPU24.PMI:Performance_monitoring_interrupts": [=0A    39344,=0A    39=
627,=0A    40008,=0A    39547,=0A    39375=0A  ],=0A  "interrupts.CPU25.PMI=
:Performance_monitoring_interrupts": [=0A    39186,=0A    39832,=0A    4000=
1,=0A    39548,=0A    39581=0A  ],=0A  "interrupts.CPU26.PMI:Performance_mo=
nitoring_interrupts": [=0A    39123,=0A    39794,=0A    40008,=0A    39614,=
=0A    39446=0A  ],=0A  "interrupts.CPU27.PMI:Performance_monitoring_interr=
upts": [=0A    39000,=0A    39799,=0A    39967,=0A    39850,=0A    39759=0A=
  ],=0A  "interrupts.CPU28.PMI:Performance_monitoring_interrupts": [=0A    =
39409,=0A    39960,=0A    40006,=0A    39313,=0A    39032=0A  ],=0A  "inter=
rupts.CPU29.PMI:Performance_monitoring_interrupts": [=0A    38979,=0A    39=
260,=0A    39903,=0A    39988,=0A    39801=0A  ],=0A  "interrupts.CPU30.PMI=
:Performance_monitoring_interrupts": [=0A    39300,=0A    39970,=0A    3959=
8,=0A    39628,=0A    39384=0A  ],=0A  "interrupts.CPU31.PMI:Performance_mo=
nitoring_interrupts": [=0A    39608,=0A    39869,=0A    40007,=0A    38982,=
=0A    39513=0A  ],=0A  "interrupts.CPU32.PMI:Performance_monitoring_interr=
upts": [=0A    39485,=0A    39847,=0A    39823,=0A    39788,=0A    39643=0A=
  ],=0A  "interrupts.CPU33.PMI:Performance_monitoring_interrupts": [=0A    =
39296,=0A    39537,=0A    39934,=0A    39837,=0A    39211=0A  ],=0A  "inter=
rupts.CPU34.PMI:Performance_monitoring_interrupts": [=0A    38843,=0A    39=
928,=0A    40007,=0A    39852,=0A    39041=0A  ],=0A  "interrupts.CPU35.PMI=
:Performance_monitoring_interrupts": [=0A    39450,=0A    39906,=0A    4000=
3,=0A    39816,=0A    39760=0A  ],=0A  "interrupts.CPU36.PMI:Performance_mo=
nitoring_interrupts": [=0A    38792,=0A    39664,=0A    39759,=0A    38692,=
=0A    38848=0A  ],=0A  "interrupts.CPU37.PMI:Performance_monitoring_interr=
upts": [=0A    38371,=0A    39985,=0A    39968,=0A    39275,=0A    38732=0A=
  ],=0A  "interrupts.CPU38.PMI:Performance_monitoring_interrupts": [=0A    =
38056,=0A    39783,=0A    39940,=0A    37537,=0A    38757=0A  ],=0A  "inter=
rupts.CPU39.PMI:Performance_monitoring_interrupts": [=0A    38354,=0A    39=
877,=0A    39942,=0A    39015,=0A    39234=0A  ],=0A  "interrupts.CPU40.PMI=
:Performance_monitoring_interrupts": [=0A    38823,=0A    39872,=0A    3984=
5,=0A    39152,=0A    38222=0A  ],=0A  "interrupts.CPU41.PMI:Performance_mo=
nitoring_interrupts": [=0A    39222,=0A    39461,=0A    39952,=0A    38300,=
=0A    38122=0A  ],=0A  "interrupts.CPU42.PMI:Performance_monitoring_interr=
upts": [=0A    38459,=0A    39466,=0A    39799,=0A    38644,=0A    39246=0A=
  ],=0A  "interrupts.CPU43.PMI:Performance_monitoring_interrupts": [=0A    =
38650,=0A    39806,=0A    39883,=0A    39144,=0A    37880=0A  ],=0A  "inter=
rupts.CPU44.PMI:Performance_monitoring_interrupts": [=0A    36587,=0A    39=
941,=0A    39942,=0A    38953,=0A    37964=0A  ],=0A  "interrupts.CPU45.PMI=
:Performance_monitoring_interrupts": [=0A    39600,=0A    39024,=0A    3993=
9,=0A    38575,=0A    38328=0A  ],=0A  "interrupts.CPU46.PMI:Performance_mo=
nitoring_interrupts": [=0A    39240,=0A    39963,=0A    39872,=0A    38928,=
=0A    39125=0A  ],=0A  "interrupts.CPU47.PMI:Performance_monitoring_interr=
upts": [=0A    39244,=0A    39454,=0A    39867,=0A    37694,=0A    38368=0A=
  ],=0A  "interrupts.PMI:Performance_monitoring_interrupts": [=0A    187008=
3,=0A    1906080,=0A    1914068,=0A    1882759,=0A    1876852=0A  ],=0A  "i=
nterrupts.CPU0.IWI:IRQ_work_interrupts": [=0A    9,=0A    10,=0A    9,=0A  =
  9,=0A    9=0A  ],=0A  "interrupts.CPU1.IWI:IRQ_work_interrupts": [=0A    =
9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU2.IWI:IRQ_w=
ork_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    10=0A  ],=0A  =
"interrupts.CPU3.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A =
   9,=0A    9=0A  ],=0A  "interrupts.CPU4.IWI:IRQ_work_interrupts": [=0A   =
 9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU5.IWI:IRQ_=
work_interrupts": [=0A    10,=0A    9,=0A    9,=0A    10,=0A    9=0A  ],=0A=
  "interrupts.CPU6.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=
=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU7.IWI:IRQ_work_interrupts": [=
=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU8.IW=
I:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ]=
,=0A  "interrupts.CPU9.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    =
9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU10.IWI:IRQ_work_interrupts": =
[=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU11.=
IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A =
 ],=0A  "interrupts.CPU12.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A =
   11,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU13.IWI:IRQ_work_interrupt=
s": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CP=
U14.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=
=0A  ],=0A  "interrupts.CPU15.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=
=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU16.IWI:IRQ_work_interr=
upts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts=
=2ECPU17.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A=
    9=0A  ],=0A  "interrupts.CPU18.IWI:IRQ_work_interrupts": [=0A    9,=0A =
   9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU19.IWI:IRQ_work_i=
nterrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "inter=
rupts.CPU20.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=
=0A    9=0A  ],=0A  "interrupts.CPU21.IWI:IRQ_work_interrupts": [=0A    9,=
=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU22.IWI:IRQ_wo=
rk_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "i=
nterrupts.CPU23.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A  =
  9,=0A    9=0A  ],=0A  "interrupts.CPU24.IWI:IRQ_work_interrupts": [=0A   =
 9,=0A    9,=0A    9,=0A    10,=0A    10=0A  ],=0A  "interrupts.CPU25.IWI:I=
RQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=
=0A  "interrupts.CPU26.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    =
9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU27.IWI:IRQ_work_interrupts": =
[=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU28.=
IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A =
 ],=0A  "interrupts.CPU29.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A =
   9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU30.IWI:IRQ_work_interrupts=
": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU=
31.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=
=0A  ],=0A  "interrupts.CPU32.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=
=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU33.IWI:IRQ_work_interr=
upts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts=
=2ECPU34.IWI:IRQ_work_interrupts": [=0A    10,=0A    9,=0A    9,=0A    9,=
=0A    9=0A  ],=0A  "interrupts.CPU35.IWI:IRQ_work_interrupts": [=0A    9,=
=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU36.IWI:IRQ_wo=
rk_interrupts": [=0A    9,=0A    10,=0A    9,=0A    9,=0A    9=0A  ],=0A  "=
interrupts.CPU37.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A =
   9,=0A    9=0A  ],=0A  "interrupts.CPU38.IWI:IRQ_work_interrupts": [=0A  =
  9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU39.IWI:IR=
Q_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A=
  "interrupts.CPU40.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=
=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU41.IWI:IRQ_work_interrupts": [=
=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU42.I=
WI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  =
],=0A  "interrupts.CPU43.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A  =
  9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU44.IWI:IRQ_work_interrupts"=
: [=0A    8,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU4=
5.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=
=0A  ],=0A  "interrupts.CPU46.IWI:IRQ_work_interrupts": [=0A    9,=0A    9,=
=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts.CPU47.IWI:IRQ_work_interr=
upts": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "interrupts=
=2EIWI:IRQ_work_interrupts": [=0A    433,=0A    434,=0A    434,=0A    434,=
=0A    434=0A  ],=0A  "interrupts.CPU0.RTR:APIC_ICR_read_retries": [=0A    =
0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "interrupts.RTR:APIC_ICR_r=
ead_retries": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "int=
errupts.CPU0.RES:Rescheduling_interrupts": [=0A    26304,=0A    26437,=0A  =
  32561,=0A    27067,=0A    27218=0A  ],=0A  "interrupts.CPU1.RES:Reschedul=
ing_interrupts": [=0A    22871,=0A    29704,=0A    24137,=0A    23122,=0A  =
  22233=0A  ],=0A  "interrupts.CPU2.RES:Rescheduling_interrupts": [=0A    2=
2013,=0A    26913,=0A    33465,=0A    26086,=0A    26243=0A  ],=0A  "interr=
upts.CPU3.RES:Rescheduling_interrupts": [=0A    23501,=0A    23450,=0A    3=
3199,=0A    23915,=0A    23850=0A  ],=0A  "interrupts.CPU4.RES:Rescheduling=
_interrupts": [=0A    24258,=0A    28248,=0A    28491,=0A    22592,=0A    2=
3511=0A  ],=0A  "interrupts.CPU5.RES:Rescheduling_interrupts": [=0A    2140=
6,=0A    24206,=0A    28695,=0A    22374,=0A    21419=0A  ],=0A  "interrupt=
s.CPU6.RES:Rescheduling_interrupts": [=0A    20801,=0A    22425,=0A    3464=
1,=0A    23536,=0A    23573=0A  ],=0A  "interrupts.CPU7.RES:Rescheduling_in=
terrupts": [=0A    20221,=0A    28558,=0A    35884,=0A    19989,=0A    2653=
5=0A  ],=0A  "interrupts.CPU8.RES:Rescheduling_interrupts": [=0A    19371,=
=0A    23677,=0A    21015,=0A    20833,=0A    22898=0A  ],=0A  "interrupts.=
CPU9.RES:Rescheduling_interrupts": [=0A    22388,=0A    22004,=0A    24400,=
=0A    21824,=0A    23585=0A  ],=0A  "interrupts.CPU10.RES:Rescheduling_int=
errupts": [=0A    23755,=0A    26582,=0A    26702,=0A    20457,=0A    20941=
=0A  ],=0A  "interrupts.CPU11.RES:Rescheduling_interrupts": [=0A    22206,=
=0A    26932,=0A    23519,=0A    22421,=0A    23133=0A  ],=0A  "interrupts.=
CPU12.RES:Rescheduling_interrupts": [=0A    29271,=0A    29725,=0A    26480=
,=0A    29374,=0A    30854=0A  ],=0A  "interrupts.CPU13.RES:Rescheduling_in=
terrupts": [=0A    32349,=0A    28868,=0A    25408,=0A    28038,=0A    2958=
8=0A  ],=0A  "interrupts.CPU14.RES:Rescheduling_interrupts": [=0A    30559,=
=0A    31268,=0A    21593,=0A    29932,=0A    29653=0A  ],=0A  "interrupts.=
CPU15.RES:Rescheduling_interrupts": [=0A    31215,=0A    27679,=0A    22688=
,=0A    29353,=0A    30709=0A  ],=0A  "interrupts.CPU16.RES:Rescheduling_in=
terrupts": [=0A    32055,=0A    29596,=0A    27319,=0A    32352,=0A    2953=
1=0A  ],=0A  "interrupts.CPU17.RES:Rescheduling_interrupts": [=0A    32891,=
=0A    25229,=0A    24061,=0A    28185,=0A    29841=0A  ],=0A  "interrupts.=
CPU18.RES:Rescheduling_interrupts": [=0A    33860,=0A    31477,=0A    33327=
,=0A    27279,=0A    28331=0A  ],=0A  "interrupts.CPU19.RES:Rescheduling_in=
terrupts": [=0A    31133,=0A    32786,=0A    30813,=0A    30639,=0A    2875=
3=0A  ],=0A  "interrupts.CPU20.RES:Rescheduling_interrupts": [=0A    31789,=
=0A    31140,=0A    29205,=0A    33181,=0A    29324=0A  ],=0A  "interrupts.=
CPU21.RES:Rescheduling_interrupts": [=0A    31990,=0A    30059,=0A    22739=
,=0A    29813,=0A    28902=0A  ],=0A  "interrupts.CPU22.RES:Rescheduling_in=
terrupts": [=0A    31360,=0A    29058,=0A    30460,=0A    32556,=0A    3213=
0=0A  ],=0A  "interrupts.CPU23.RES:Rescheduling_interrupts": [=0A    31910,=
=0A    31003,=0A    32353,=0A    28699,=0A    32135=0A  ],=0A  "interrupts.=
CPU24.RES:Rescheduling_interrupts": [=0A    20448,=0A    22379,=0A    13855=
,=0A    23502,=0A    23681=0A  ],=0A  "interrupts.CPU25.RES:Rescheduling_in=
terrupts": [=0A    19980,=0A    21864,=0A    28983,=0A    16015,=0A    2344=
9=0A  ],=0A  "interrupts.CPU26.RES:Rescheduling_interrupts": [=0A    20962,=
=0A    27558,=0A    26672,=0A    21028,=0A    20618=0A  ],=0A  "interrupts.=
CPU27.RES:Rescheduling_interrupts": [=0A    20732,=0A    21112,=0A    17658=
,=0A    20023,=0A    22836=0A  ],=0A  "interrupts.CPU28.RES:Rescheduling_in=
terrupts": [=0A    20098,=0A    20503,=0A    16046,=0A    18957,=0A    1872=
9=0A  ],=0A  "interrupts.CPU29.RES:Rescheduling_interrupts": [=0A    19033,=
=0A    24591,=0A    30082,=0A    17497,=0A    20768=0A  ],=0A  "interrupts.=
CPU30.RES:Rescheduling_interrupts": [=0A    21669,=0A    21870,=0A    23923=
,=0A    18324,=0A    20635=0A  ],=0A  "interrupts.CPU31.RES:Rescheduling_in=
terrupts": [=0A    19652,=0A    20816,=0A    14654,=0A    16627,=0A    2237=
6=0A  ],=0A  "interrupts.CPU32.RES:Rescheduling_interrupts": [=0A    20206,=
=0A    19569,=0A    15766,=0A    15012,=0A    22100=0A  ],=0A  "interrupts.=
CPU33.RES:Rescheduling_interrupts": [=0A    18966,=0A    22093,=0A    30309=
,=0A    19701,=0A    20142=0A  ],=0A  "interrupts.CPU34.RES:Rescheduling_in=
terrupts": [=0A    22195,=0A    15496,=0A    20559,=0A    22131,=0A    2139=
7=0A  ],=0A  "interrupts.CPU35.RES:Rescheduling_interrupts": [=0A    20356,=
=0A    19718,=0A    23068,=0A    21894,=0A    21579=0A  ],=0A  "interrupts.=
CPU36.RES:Rescheduling_interrupts": [=0A    30516,=0A    24752,=0A    27726=
,=0A    29365,=0A    32193=0A  ],=0A  "interrupts.CPU37.RES:Rescheduling_in=
terrupts": [=0A    33047,=0A    25443,=0A    28849,=0A    32687,=0A    3503=
1=0A  ],=0A  "interrupts.CPU38.RES:Rescheduling_interrupts": [=0A    31839,=
=0A    30279,=0A    18115,=0A    31071,=0A    31120=0A  ],=0A  "interrupts.=
CPU39.RES:Rescheduling_interrupts": [=0A    30978,=0A    28513,=0A    28354=
,=0A    30324,=0A    27251=0A  ],=0A  "interrupts.CPU40.RES:Rescheduling_in=
terrupts": [=0A    34047,=0A    25107,=0A    25587,=0A    30569,=0A    2731=
2=0A  ],=0A  "interrupts.CPU41.RES:Rescheduling_interrupts": [=0A    27569,=
=0A    31283,=0A    21073,=0A    30819,=0A    31998=0A  ],=0A  "interrupts.=
CPU42.RES:Rescheduling_interrupts": [=0A    31123,=0A    25435,=0A    26882=
,=0A    34404,=0A    30045=0A  ],=0A  "interrupts.CPU43.RES:Rescheduling_in=
terrupts": [=0A    33687,=0A    26049,=0A    16513,=0A    29245,=0A    2693=
7=0A  ],=0A  "interrupts.CPU44.RES:Rescheduling_interrupts": [=0A    32340,=
=0A    30288,=0A    26546,=0A    32432,=0A    31432=0A  ],=0A  "interrupts.=
CPU45.RES:Rescheduling_interrupts": [=0A    31842,=0A    26435,=0A    31620=
,=0A    24041,=0A    29755=0A  ],=0A  "interrupts.CPU46.RES:Rescheduling_in=
terrupts": [=0A    33764,=0A    28802,=0A    23464,=0A    27177,=0A    2734=
0=0A  ],=0A  "interrupts.CPU47.RES:Rescheduling_interrupts": [=0A    31357,=
=0A    26294,=0A    27050,=0A    29282,=0A    28424=0A  ],=0A  "interrupts.=
RES:Rescheduling_interrupts": [=0A    1275883,=0A    1253273,=0A    1236509=
,=0A    1225744,=0A    1262038=0A  ],=0A  "interrupts.CPU0.CAL:Function_cal=
l_interrupts": [=0A    202,=0A    106,=0A    33,=0A    108,=0A    163=0A  ]=
,=0A  "interrupts.CPU1.CAL:Function_call_interrupts": [=0A    171,=0A    78=
,=0A    20,=0A    78,=0A    168=0A  ],=0A  "interrupts.CPU2.CAL:Function_ca=
ll_interrupts": [=0A    156,=0A    72,=0A    14,=0A    84,=0A    148=0A  ],=
=0A  "interrupts.CPU3.CAL:Function_call_interrupts": [=0A    182,=0A    62,=
=0A    20,=0A    92,=0A    129=0A  ],=0A  "interrupts.CPU4.CAL:Function_cal=
l_interrupts": [=0A    168,=0A    58,=0A    18,=0A    66,=0A    164=0A  ],=
=0A  "interrupts.CPU5.CAL:Function_call_interrupts": [=0A    153,=0A    70,=
=0A    24,=0A    74,=0A    142=0A  ],=0A  "interrupts.CPU6.CAL:Function_cal=
l_interrupts": [=0A    140,=0A    75,=0A    15,=0A    68,=0A    146=0A  ],=
=0A  "interrupts.CPU7.CAL:Function_call_interrupts": [=0A    155,=0A    60,=
=0A    14,=0A    87,=0A    152=0A  ],=0A  "interrupts.CPU8.CAL:Function_cal=
l_interrupts": [=0A    140,=0A    82,=0A    9,=0A    88,=0A    145=0A  ],=
=0A  "interrupts.CPU9.CAL:Function_call_interrupts": [=0A    134,=0A    65,=
=0A    13,=0A    64,=0A    145=0A  ],=0A  "interrupts.CPU10.CAL:Function_ca=
ll_interrupts": [=0A    165,=0A    47,=0A    10,=0A    71,=0A    135=0A  ],=
=0A  "interrupts.CPU11.CAL:Function_call_interrupts": [=0A    157,=0A    51=
,=0A    13,=0A    64,=0A    138=0A  ],=0A  "interrupts.CPU12.CAL:Function_c=
all_interrupts": [=0A    61,=0A    67,=0A    32,=0A    46,=0A    66=0A  ],=
=0A  "interrupts.CPU13.CAL:Function_call_interrupts": [=0A    49,=0A    36,=
=0A    23,=0A    40,=0A    43=0A  ],=0A  "interrupts.CPU14.CAL:Function_cal=
l_interrupts": [=0A    55,=0A    40,=0A    16,=0A    38,=0A    38=0A  ],=0A=
  "interrupts.CPU15.CAL:Function_call_interrupts": [=0A    44,=0A    33,=0A=
    19,=0A    40,=0A    50=0A  ],=0A  "interrupts.CPU16.CAL:Function_call_i=
nterrupts": [=0A    38,=0A    34,=0A    17,=0A    37,=0A    48=0A  ],=0A  "=
interrupts.CPU17.CAL:Function_call_interrupts": [=0A    49,=0A    32,=0A   =
 10,=0A    45,=0A    41=0A  ],=0A  "interrupts.CPU18.CAL:Function_call_inte=
rrupts": [=0A    54,=0A    32,=0A    18,=0A    33,=0A    46=0A  ],=0A  "int=
errupts.CPU19.CAL:Function_call_interrupts": [=0A    44,=0A    32,=0A    17=
,=0A    33,=0A    45=0A  ],=0A  "interrupts.CPU20.CAL:Function_call_interru=
pts": [=0A    36,=0A    35,=0A    13,=0A    30,=0A    43=0A  ],=0A  "interr=
upts.CPU21.CAL:Function_call_interrupts": [=0A    30,=0A    33,=0A    12,=
=0A    39,=0A    47=0A  ],=0A  "interrupts.CPU22.CAL:Function_call_interrup=
ts": [=0A    45,=0A    29,=0A    14,=0A    31,=0A    48=0A  ],=0A  "interru=
pts.CPU23.CAL:Function_call_interrupts": [=0A    32,=0A    38,=0A    23,=0A=
    32,=0A    39=0A  ],=0A  "interrupts.CPU24.CAL:Function_call_interrupts"=
: [=0A    46,=0A    22,=0A    7,=0A    27,=0A    48=0A  ],=0A  "interrupts.=
CPU25.CAL:Function_call_interrupts": [=0A    56,=0A    20,=0A    7,=0A    2=
3,=0A    42=0A  ],=0A  "interrupts.CPU26.CAL:Function_call_interrupts": [=
=0A    56,=0A    22,=0A    6,=0A    26,=0A    46=0A  ],=0A  "interrupts.CPU=
27.CAL:Function_call_interrupts": [=0A    50,=0A    17,=0A    8,=0A    28,=
=0A    46=0A  ],=0A  "interrupts.CPU28.CAL:Function_call_interrupts": [=0A =
   48,=0A    18,=0A    8,=0A    28,=0A    55=0A  ],=0A  "interrupts.CPU29.C=
AL:Function_call_interrupts": [=0A    53,=0A    17,=0A    7,=0A    22,=0A  =
  54=0A  ],=0A  "interrupts.CPU30.CAL:Function_call_interrupts": [=0A    51=
,=0A    17,=0A    7,=0A    21,=0A    40=0A  ],=0A  "interrupts.CPU31.CAL:Fu=
nction_call_interrupts": [=0A    41,=0A    18,=0A    7,=0A    30,=0A    45=
=0A  ],=0A  "interrupts.CPU32.CAL:Function_call_interrupts": [=0A    46,=0A=
    23,=0A    7,=0A    28,=0A    33=0A  ],=0A  "interrupts.CPU33.CAL:Functi=
on_call_interrupts": [=0A    46,=0A    14,=0A    7,=0A    22,=0A    33=0A  =
],=0A  "interrupts.CPU34.CAL:Function_call_interrupts": [=0A    48,=0A    1=
0,=0A    8,=0A    22,=0A    44=0A  ],=0A  "interrupts.CPU35.CAL:Function_ca=
ll_interrupts": [=0A    48,=0A    20,=0A    8,=0A    26,=0A    32=0A  ],=0A=
  "interrupts.CPU36.CAL:Function_call_interrupts": [=0A    6,=0A    6,=0A  =
  6,=0A    4,=0A    6=0A  ],=0A  "interrupts.CPU37.CAL:Function_call_interr=
upts": [=0A    0,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts=
=2ECPU38.CAL:Function_call_interrupts": [=0A    6,=0A    6,=0A    6,=0A    =
6,=0A    6=0A  ],=0A  "interrupts.CPU39.CAL:Function_call_interrupts": [=0A=
    6,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU40.CAL:=
Function_call_interrupts": [=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=0A=
  ],=0A  "interrupts.CPU41.CAL:Function_call_interrupts": [=0A    6,=0A    =
6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU42.CAL:Function_call=
_interrupts": [=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "int=
errupts.CPU43.CAL:Function_call_interrupts": [=0A    6,=0A    6,=0A    6,=
=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU44.CAL:Function_call_interrupts=
": [=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU=
45.CAL:Function_call_interrupts": [=0A    6,=0A    6,=0A    6,=0A    6,=0A =
   6=0A  ],=0A  "interrupts.CPU46.CAL:Function_call_interrupts": [=0A    6,=
=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=0A  "interrupts.CPU47.CAL:Functi=
on_call_interrupts": [=0A    6,=0A    6,=0A    6,=0A    6,=0A    6=0A  ],=
=0A  "interrupts.CAL:Function_call_interrupts": [=0A    3115,=0A    1557,=
=0A    576,=0A    1761,=0A    2919=0A  ],=0A  "interrupts.CPU0.TLB:TLB_shoo=
tdowns": [=0A    45944,=0A    18943,=0A    4357,=0A    22888,=0A    41757=
=0A  ],=0A  "interrupts.CPU1.TLB:TLB_shootdowns": [=0A    46028,=0A    1862=
7,=0A    4416,=0A    23077,=0A    41477=0A  ],=0A  "interrupts.CPU2.TLB:TLB=
_shootdowns": [=0A    45712,=0A    18881,=0A    4294,=0A    22895,=0A    40=
895=0A  ],=0A  "interrupts.CPU3.TLB:TLB_shootdowns": [=0A    45615,=0A    1=
8892,=0A    4421,=0A    23124,=0A    40883=0A  ],=0A  "interrupts.CPU4.TLB:=
TLB_shootdowns": [=0A    45807,=0A    18882,=0A    4388,=0A    23164,=0A   =
 41056=0A  ],=0A  "interrupts.CPU5.TLB:TLB_shootdowns": [=0A    46248,=0A  =
  18808,=0A    4510,=0A    22997,=0A    41274=0A  ],=0A  "interrupts.CPU6.T=
LB:TLB_shootdowns": [=0A    46201,=0A    18759,=0A    4371,=0A    23062,=0A=
    41479=0A  ],=0A  "interrupts.CPU7.TLB:TLB_shootdowns": [=0A    46121,=
=0A    18567,=0A    4315,=0A    23114,=0A    40955=0A  ],=0A  "interrupts.C=
PU8.TLB:TLB_shootdowns": [=0A    46186,=0A    18734,=0A    4563,=0A    2306=
8,=0A    41089=0A  ],=0A  "interrupts.CPU9.TLB:TLB_shootdowns": [=0A    460=
60,=0A    18861,=0A    4329,=0A    22890,=0A    41137=0A  ],=0A  "interrupt=
s.CPU10.TLB:TLB_shootdowns": [=0A    45599,=0A    18679,=0A    4425,=0A    =
23191,=0A    41326=0A  ],=0A  "interrupts.CPU11.TLB:TLB_shootdowns": [=0A  =
  45722,=0A    18841,=0A    4361,=0A    23297,=0A    41134=0A  ],=0A  "inte=
rrupts.CPU12.TLB:TLB_shootdowns": [=0A    45048,=0A    18534,=0A    4382,=
=0A    22486,=0A    40359=0A  ],=0A  "interrupts.CPU13.TLB:TLB_shootdowns":=
 [=0A    44770,=0A    18485,=0A    4362,=0A    22530,=0A    40475=0A  ],=0A=
  "interrupts.CPU14.TLB:TLB_shootdowns": [=0A    45145,=0A    18398,=0A    =
4394,=0A    23085,=0A    40578=0A  ],=0A  "interrupts.CPU15.TLB:TLB_shootdo=
wns": [=0A    45971,=0A    18524,=0A    4362,=0A    22274,=0A    40221=0A  =
],=0A  "interrupts.CPU16.TLB:TLB_shootdowns": [=0A    44735,=0A    18346,=
=0A    4226,=0A    22129,=0A    40323=0A  ],=0A  "interrupts.CPU17.TLB:TLB_=
shootdowns": [=0A    44563,=0A    18662,=0A    4345,=0A    22214,=0A    404=
44=0A  ],=0A  "interrupts.CPU18.TLB:TLB_shootdowns": [=0A    44191,=0A    1=
8326,=0A    4330,=0A    22490,=0A    40374=0A  ],=0A  "interrupts.CPU19.TLB=
:TLB_shootdowns": [=0A    44814,=0A    18307,=0A    4422,=0A    22462,=0A  =
  40268=0A  ],=0A  "interrupts.CPU20.TLB:TLB_shootdowns": [=0A    44988,=0A=
    18304,=0A    4320,=0A    22373,=0A    40578=0A  ],=0A  "interrupts.CPU2=
1.TLB:TLB_shootdowns": [=0A    45043,=0A    18509,=0A    4150,=0A    22348,=
=0A    40429=0A  ],=0A  "interrupts.CPU22.TLB:TLB_shootdowns": [=0A    4489=
5,=0A    18620,=0A    4318,=0A    22351,=0A    39791=0A  ],=0A  "interrupts=
=2ECPU23.TLB:TLB_shootdowns": [=0A    45284,=0A    18302,=0A    4266,=0A   =
 22222,=0A    39999=0A  ],=0A  "interrupts.CPU24.TLB:TLB_shootdowns": [=0A =
   46399,=0A    18817,=0A    4533,=0A    23389,=0A    41060=0A  ],=0A  "int=
errupts.CPU25.TLB:TLB_shootdowns": [=0A    46577,=0A    18952,=0A    4452,=
=0A    23615,=0A    40581=0A  ],=0A  "interrupts.CPU26.TLB:TLB_shootdowns":=
 [=0A    46291,=0A    18807,=0A    4426,=0A    22913,=0A    41261=0A  ],=0A=
  "interrupts.CPU27.TLB:TLB_shootdowns": [=0A    46066,=0A    18778,=0A    =
4520,=0A    23538,=0A    41324=0A  ],=0A  "interrupts.CPU28.TLB:TLB_shootdo=
wns": [=0A    46045,=0A    18993,=0A    4497,=0A    23242,=0A    41455=0A  =
],=0A  "interrupts.CPU29.TLB:TLB_shootdowns": [=0A    46318,=0A    18512,=
=0A    4278,=0A    23410,=0A    41194=0A  ],=0A  "interrupts.CPU30.TLB:TLB_=
shootdowns": [=0A    45813,=0A    18939,=0A    4409,=0A    23599,=0A    414=
50=0A  ],=0A  "interrupts.CPU31.TLB:TLB_shootdowns": [=0A    46091,=0A    1=
9207,=0A    4588,=0A    23334,=0A    41249=0A  ],=0A  "interrupts.CPU32.TLB=
:TLB_shootdowns": [=0A    46225,=0A    19169,=0A    4596,=0A    23728,=0A  =
  41248=0A  ],=0A  "interrupts.CPU33.TLB:TLB_shootdowns": [=0A    46140,=0A=
    19008,=0A    4462,=0A    23426,=0A    41631=0A  ],=0A  "interrupts.CPU3=
4.TLB:TLB_shootdowns": [=0A    45913,=0A    19417,=0A    4597,=0A    23194,=
=0A    41165=0A  ],=0A  "interrupts.CPU35.TLB:TLB_shootdowns": [=0A    4554=
4,=0A    19128,=0A    4519,=0A    23173,=0A    41145=0A  ],=0A  "interrupts=
=2ECPU36.TLB:TLB_shootdowns": [=0A    44425,=0A    18659,=0A    4195,=0A   =
 22368,=0A    40102=0A  ],=0A  "interrupts.CPU37.TLB:TLB_shootdowns": [=0A =
   44030,=0A    18715,=0A    4356,=0A    21751,=0A    39811=0A  ],=0A  "int=
errupts.CPU38.TLB:TLB_shootdowns": [=0A    43969,=0A    18356,=0A    4242,=
=0A    21573,=0A    39770=0A  ],=0A  "interrupts.CPU39.TLB:TLB_shootdowns":=
 [=0A    44171,=0A    18065,=0A    4262,=0A    21720,=0A    39995=0A  ],=0A=
  "interrupts.CPU40.TLB:TLB_shootdowns": [=0A    44378,=0A    18471,=0A    =
4163,=0A    21812,=0A    40132=0A  ],=0A  "interrupts.CPU41.TLB:TLB_shootdo=
wns": [=0A    44711,=0A    18175,=0A    4274,=0A    21807,=0A    39180=0A  =
],=0A  "interrupts.CPU42.TLB:TLB_shootdowns": [=0A    44117,=0A    18494,=
=0A    4228,=0A    21910,=0A    39829=0A  ],=0A  "interrupts.CPU43.TLB:TLB_=
shootdowns": [=0A    43682,=0A    18690,=0A    4119,=0A    22169,=0A    399=
06=0A  ],=0A  "interrupts.CPU44.TLB:TLB_shootdowns": [=0A    44147,=0A    1=
8117,=0A    4230,=0A    21809,=0A    39436=0A  ],=0A  "interrupts.CPU45.TLB=
:TLB_shootdowns": [=0A    44319,=0A    18343,=0A    4253,=0A    22260,=0A  =
  39406=0A  ],=0A  "interrupts.CPU46.TLB:TLB_shootdowns": [=0A    43418,=0A=
    18076,=0A    4209,=0A    22280,=0A    40283=0A  ],=0A  "interrupts.CPU4=
7.TLB:TLB_shootdowns": [=0A    44269,=0A    18444,=0A    4140,=0A    21993,=
=0A    39585=0A  ],=0A  "interrupts.TLB:TLB_shootdowns": [=0A    2173748,=
=0A    895123,=0A    209175,=0A    1089744,=0A    1950499=0A  ],=0A  "inter=
rupts.CPU0.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=
=0A    2=0A  ],=0A  "interrupts.CPU1.MCP:Machine_check_polls": [=0A    2,=
=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU2.MCP:Machine=
_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "in=
terrupts.CPU3.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    =
2,=0A    2=0A  ],=0A  "interrupts.CPU4.MCP:Machine_check_polls": [=0A    2,=
=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU5.MCP:Machine=
_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "in=
terrupts.CPU6.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    =
2,=0A    2=0A  ],=0A  "interrupts.CPU7.MCP:Machine_check_polls": [=0A    2,=
=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU8.MCP:Machine=
_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "in=
terrupts.CPU9.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    =
2,=0A    2=0A  ],=0A  "interrupts.CPU10.MCP:Machine_check_polls": [=0A    2=
,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU11.MCP:Machi=
ne_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "=
interrupts.CPU12.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A =
   2,=0A    2=0A  ],=0A  "interrupts.CPU13.MCP:Machine_check_polls": [=0A  =
  2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU14.MCP:Ma=
chine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A=
  "interrupts.CPU15.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=
=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU16.MCP:Machine_check_polls": [=
=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU17.M=
CP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  =
],=0A  "interrupts.CPU18.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A  =
  2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU19.MCP:Machine_check_polls"=
: [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU2=
0.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=
=0A  ],=0A  "interrupts.CPU21.MCP:Machine_check_polls": [=0A    2,=0A    2,=
=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU22.MCP:Machine_check_p=
olls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts=
=2ECPU23.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A=
    2=0A  ],=0A  "interrupts.CPU24.MCP:Machine_check_polls": [=0A    2,=0A =
   2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU25.MCP:Machine_ch=
eck_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "inter=
rupts.CPU26.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=
=0A    2=0A  ],=0A  "interrupts.CPU27.MCP:Machine_check_polls": [=0A    2,=
=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU28.MCP:Machin=
e_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "i=
nterrupts.CPU29.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A  =
  2,=0A    2=0A  ],=0A  "interrupts.CPU30.MCP:Machine_check_polls": [=0A   =
 2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU31.MCP:Mac=
hine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A =
 "interrupts.CPU32.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=
=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU33.MCP:Machine_check_polls": [=
=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU34.M=
CP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  =
],=0A  "interrupts.CPU35.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A  =
  2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU36.MCP:Machine_check_polls"=
: [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU3=
7.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=
=0A  ],=0A  "interrupts.CPU38.MCP:Machine_check_polls": [=0A    2,=0A    2,=
=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU39.MCP:Machine_check_p=
olls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts=
=2ECPU40.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A=
    2=0A  ],=0A  "interrupts.CPU41.MCP:Machine_check_polls": [=0A    2,=0A =
   2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU42.MCP:Machine_ch=
eck_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "inter=
rupts.CPU43.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=
=0A    2=0A  ],=0A  "interrupts.CPU44.MCP:Machine_check_polls": [=0A    2,=
=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.CPU45.MCP:Machin=
e_check_polls": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "i=
nterrupts.CPU46.MCP:Machine_check_polls": [=0A    2,=0A    2,=0A    2,=0A  =
  2,=0A    2=0A  ],=0A  "interrupts.CPU47.MCP:Machine_check_polls": [=0A   =
 2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "interrupts.MCP:Machine_c=
heck_polls": [=0A    96,=0A    96,=0A    96,=0A    96,=0A    96=0A  ],=0A  =
"numa-numastat.node0.numa_hit": [=0A    470085801,=0A    477956026,=0A    4=
86395959,=0A    480660364,=0A    475329679=0A  ],=0A  "numa-numastat.node0.=
interleave_hit": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "=
numa-numastat.node0.local_node": [=0A    470078461,=0A    477955774,=0A    =
486389558,=0A    480659882,=0A    475328828=0A  ],=0A  "numa-numastat.node0=
=2Eother_node": [=0A    7340,=0A    252,=0A    6401,=0A    482,=0A    851=
=0A  ],=0A  "numa-numastat.node1.numa_hit": [=0A    451345174,=0A    442566=
408,=0A    447886811,=0A    451597154,=0A    452745744=0A  ],=0A  "numa-num=
astat.node1.interleave_hit": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=
=0A  ],=0A  "numa-numastat.node1.local_node": [=0A    451345145,=0A    4425=
60058,=0A    447886804,=0A    451590807,=0A    452739392=0A  ],=0A  "numa-n=
umastat.node1.other_node": [=0A    29,=0A    6350,=0A    7,=0A    6347,=0A =
   6352=0A  ],=0A  "vmstat.procs.r": [=0A    49,=0A    49,=0A    49,=0A    =
49,=0A    49=0A  ],=0A  "vmstat.procs.b": [=0A    0,=0A    0,=0A    0,=0A  =
  0,=0A    0=0A  ],=0A  "vmstat.memory.free": [=0A    63458359,=0A    63455=
439,=0A    63464388,=0A    63458480,=0A    63457757=0A  ],=0A  "vmstat.memo=
ry.cache": [=0A    1684650,=0A    1687671,=0A    1687865,=0A    1686646,=0A=
    1685753=0A  ],=0A  "vmstat.system.in": [=0A    56875,=0A    55679,=0A  =
  55099,=0A    55794,=0A    56657=0A  ],=0A  "vmstat.system.cs": [=0A    10=
699,=0A    7055,=0A    5136,=0A    7563,=0A    10037=0A  ],=0A  "vmstat.cpu=
=2Eus": [=0A    27,=0A    27,=0A    27,=0A    26,=0A    27=0A  ],=0A  "vmst=
at.cpu.sy": [=0A    69,=0A    70,=0A    71,=0A    71,=0A    70=0A  ],=0A  "=
vmstat.cpu.id": [=0A    1,=0A    1,=0A    0,=0A    1,=0A    1=0A  ],=0A  "v=
mstat.cpu.wa": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "pr=
oc-vmstat.nr_free_pages": [=0A    15864497,=0A    15864040,=0A    15866031,=
=0A    15864572,=0A    15864261=0A  ],=0A  "proc-vmstat.nr_alloc_batch": [=
=0A    3471,=0A    3479,=0A    3490,=0A    3532,=0A    3564=0A  ],=0A  "pro=
c-vmstat.nr_inactive_anon": [=0A    1124,=0A    1208,=0A    1200,=0A    113=
4,=0A    1129=0A  ],=0A  "proc-vmstat.nr_active_anon": [=0A    58210,=0A   =
 59057,=0A    59348,=0A    58660,=0A    58417=0A  ],=0A  "proc-vmstat.nr_in=
active_file": [=0A    295265,=0A    294552,=0A    294458,=0A    294814,=0A =
   295211=0A  ],=0A  "proc-vmstat.nr_active_file": [=0A    75315,=0A    754=
01,=0A    75212,=0A    75393,=0A    75243=0A  ],=0A  "proc-vmstat.nr_anon_p=
ages": [=0A    8565,=0A    8596,=0A    8437,=0A    8505,=0A    8552=0A  ],=
=0A  "proc-vmstat.nr_mapped": [=0A    2811,=0A    2932,=0A    2932,=0A    2=
842,=0A    2852=0A  ],=0A  "proc-vmstat.nr_file_pages": [=0A    421249,=0A =
   421782,=0A    422134,=0A    421654,=0A    421502=0A  ],=0A  "proc-vmstat=
=2Enr_dirty": [=0A    3,=0A    3,=0A    3,=0A    3,=0A    3=0A  ],=0A  "pro=
c-vmstat.nr_writeback": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ]=
,=0A  "proc-vmstat.nr_slab_reclaimable": [=0A    18590,=0A    18636,=0A    =
18731,=0A    18597,=0A    18486=0A  ],=0A  "proc-vmstat.nr_slab_unreclaimab=
le": [=0A    28191,=0A    28518,=0A    28355,=0A    28080,=0A    28481=0A  =
],=0A  "proc-vmstat.nr_page_table_pages": [=0A    1058,=0A    1050,=0A    1=
106,=0A    1154,=0A    1053=0A  ],=0A  "proc-vmstat.nr_kernel_stack": [=0A =
   1126,=0A    1125,=0A    1126,=0A    1126,=0A    1126=0A  ],=0A  "proc-vm=
stat.nr_isolated_anon": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ]=
,=0A  "proc-vmstat.nr_shmem": [=0A    50770,=0A    51671,=0A    52112,=0A  =
  51290,=0A    50997=0A  ],=0A  "proc-vmstat.nr_dirtied": [=0A    175,=0A  =
  175,=0A    174,=0A    126,=0A    176=0A  ],=0A  "proc-vmstat.nr_written":=
 [=0A    172,=0A    142,=0A    142,=0A    91,=0A    171=0A  ],=0A  "proc-vm=
stat.numa_hit": [=0A    921424458,=0A    920515063,=0A    934275434,=0A    =
932259966,=0A    928069754=0A  ],=0A  "proc-vmstat.numa_interleave": [=0A  =
  0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "proc-vmstat.numa_local"=
: [=0A    921417089,=0A    920508461,=0A    934269026,=0A    932253137,=0A =
   928062552=0A  ],=0A  "proc-vmstat.numa_other": [=0A    7369,=0A    6602,=
=0A    6408,=0A    6829,=0A    7202=0A  ],=0A  "proc-vmstat.nr_anon_transpa=
rent_hugepages": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "=
proc-vmstat.nr_dirty_threshold": [=0A    3233634,=0A    3233420,=0A    3233=
760,=0A    3233574,=0A    3233562=0A  ],=0A  "proc-vmstat.nr_dirty_backgrou=
nd_threshold": [=0A    1616816,=0A    1616709,=0A    1616880,=0A    1616786=
,=0A    1616781=0A  ],=0A  "proc-vmstat.pgalloc_dma": [=0A    0,=0A    0,=
=0A    0,=0A    0,=0A    0=0A  ],=0A  "proc-vmstat.pgalloc_dma32": [=0A    =
45710012,=0A    46545027,=0A    47422363,=0A    46750489,=0A    46283032=0A=
  ],=0A  "proc-vmstat.pgalloc_normal": [=0A    913746051,=0A    911479735,=
=0A    925374026,=0A    924742553,=0A    920691339=0A  ],=0A  "proc-vmstat.=
pgfree": [=0A    959391932,=0A    957959414,=0A    972730722,=0A    9714275=
38,=0A    966909399=0A  ],=0A  "proc-vmstat.pgactivate": [=0A    21831809,=
=0A    21816688,=0A    22139447,=0A    22077518,=0A    21989487=0A  ],=0A  =
"proc-vmstat.pgfault": [=0A    4327048,=0A    2997073,=0A    2170097,=0A   =
 3192185,=0A    4111528=0A  ],=0A  "proc-vmstat.pageoutrun": [=0A    0,=0A =
   0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "proc-vmstat.numa_pte_updates": =
[=0A    495798,=0A    374143,=0A    205283,=0A    391457,=0A    488108=0A  =
],=0A  "proc-vmstat.numa_hint_faults": [=0A    495293,=0A    376382,=0A    =
204869,=0A    390806,=0A    489409=0A  ],=0A  "proc-vmstat.numa_hint_faults=
_local": [=0A    458500,=0A    351414,=0A    190470,=0A    363399,=0A    45=
4009=0A  ],=0A  "proc-vmstat.numa_pages_migrated": [=0A    1715,=0A    1012=
,=0A    695,=0A    1300,=0A    2134=0A  ],=0A  "proc-vmstat.pgmigrate_succe=
ss": [=0A    1715,=0A    1012,=0A    695,=0A    1300,=0A    2134=0A  ],=0A =
 "proc-vmstat.thp_fault_alloc": [=0A    1,=0A    1,=0A    0,=0A    0,=0A   =
 1=0A  ],=0A  "proc-vmstat.thp_collapse_alloc": [=0A    2,=0A    1,=0A    2=
,=0A    2,=0A    1=0A  ],=0A  "meminfo.MemTotal": [=0A    65869268,=0A    6=
5869268,=0A    65869268,=0A    65869268,=0A    65869268=0A  ],=0A  "meminfo=
=2EMemFree": [=0A    63458441,=0A    63454691,=0A    63462495,=0A    634581=
40,=0A    63456403=0A  ],=0A  "meminfo.MemAvailable": [=0A    64752470,=0A =
   64748309,=0A    64755277,=0A    64751321,=0A    64750316=0A  ],=0A  "mem=
info.Cached": [=0A    1684902,=0A    1688968,=0A    1690344,=0A    1686944,=
=0A    1686079=0A  ],=0A  "meminfo.Active": [=0A    534031,=0A    538311,=
=0A    538296,=0A    536102,=0A    534588=0A  ],=0A  "meminfo.Inactive": [=
=0A    1185430,=0A    1184368,=0A    1184424,=0A    1184319,=0A    1185714=
=0A  ],=0A  "meminfo.Active(anon)": [=0A    232844,=0A    236513,=0A    237=
387,=0A    234642,=0A    233667=0A  ],=0A  "meminfo.Inactive(anon)": [=0A  =
  4485,=0A    4555,=0A    4792,=0A    4530,=0A    4517=0A  ],=0A  "meminfo.=
Active(file)": [=0A    301186,=0A    301797,=0A    300908,=0A    301459,=0A=
    300920=0A  ],=0A  "meminfo.Inactive(file)": [=0A    1180944,=0A    1179=
812,=0A    1179632,=0A    1179788,=0A    1181197=0A  ],=0A  "meminfo.Dirty"=
: [=0A    15,=0A    14,=0A    14,=0A    14,=0A    14=0A  ],=0A  "meminfo.An=
onPages": [=0A    34262,=0A    34375,=0A    33747,=0A    34025,=0A    34205=
=0A  ],=0A  "meminfo.Mapped": [=0A    11245,=0A    11323,=0A    11626,=0A  =
  11387,=0A    11409=0A  ],=0A  "meminfo.Shmem": [=0A    203068,=0A    2066=
97,=0A    208434,=0A    205156,=0A    203987=0A  ],=0A  "meminfo.Slab": [=
=0A    186839,=0A    188314,=0A    188456,=0A    186730,=0A    188270=0A  ]=
,=0A  "meminfo.SReclaimable": [=0A    74290,=0A    74509,=0A    74980,=0A  =
  74361,=0A    74088=0A  ],=0A  "meminfo.SUnreclaim": [=0A    112548,=0A   =
 113804,=0A    113475,=0A    112368,=0A    114182=0A  ],=0A  "meminfo.Kerne=
lStack": [=0A    18020,=0A    18008,=0A    18018,=0A    18022,=0A    18021=
=0A  ],=0A  "meminfo.PageTables": [=0A    4236,=0A    4203,=0A    4425,=0A =
   4621,=0A    4212=0A  ],=0A  "meminfo.CommitLimit": [=0A    32934632,=0A =
   32934632,=0A    32934632,=0A    32934632,=0A    32934632=0A  ],=0A  "mem=
info.Committed_AS": [=0A    287307,=0A    294694,=0A    297217,=0A    28415=
4,=0A    291535=0A  ],=0A  "meminfo.VmallocTotal": [=0A    34359738367,=0A =
   34359738367,=0A    34359738367,=0A    34359738367,=0A    34359738367=0A =
 ],=0A  "meminfo.VmallocUsed": [=0A    414936,=0A    414936,=0A    414936,=
=0A    414936,=0A    414936=0A  ],=0A  "meminfo.VmallocChunk": [=0A    3432=
5786620,=0A    34325786620,=0A    34325786620,=0A    34325786620,=0A    343=
25786620=0A  ],=0A  "meminfo.AnonHugePages": [=0A    4067,=0A    2048,=0A  =
  4037,=0A    4037,=0A    2050=0A  ],=0A  "meminfo.Hugepagesize": [=0A    2=
048,=0A    2048,=0A    2048,=0A    2048,=0A    2048=0A  ],=0A  "meminfo.Dir=
ectMap4k": [=0A    77620,=0A    69428,=0A    81716,=0A    79668,=0A    7147=
6=0A  ],=0A  "meminfo.DirectMap2M": [=0A    7182336,=0A    7190528,=0A    7=
178240,=0A    6131712,=0A    7188480=0A  ],=0A  "meminfo.DirectMap1G": [=0A=
    61865984,=0A    61865984,=0A    61865984,=0A    62914560,=0A    6186598=
4=0A  ],=0A  "slabinfo.RAWv6.active_objs": [=0A    270,=0A    270,=0A    27=
0,=0A    270,=0A    270=0A  ],=0A  "slabinfo.RAWv6.num_objs": [=0A    270,=
=0A    270,=0A    270,=0A    270,=0A    270=0A  ],=0A  "slabinfo.RAWv6.acti=
ve_slabs": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=0A  "slabin=
fo.RAWv6.num_slabs": [=0A    9,=0A    9,=0A    9,=0A    9,=0A    9=0A  ],=
=0A  "slabinfo.UDPv6.active_objs": [=0A    150,=0A    180,=0A    120,=0A   =
 150,=0A    120=0A  ],=0A  "slabinfo.UDPv6.num_objs": [=0A    150,=0A    18=
0,=0A    120,=0A    150,=0A    120=0A  ],=0A  "slabinfo.UDPv6.active_slabs"=
: [=0A    5,=0A    6,=0A    4,=0A    5,=0A    4=0A  ],=0A  "slabinfo.UDPv6.=
num_slabs": [=0A    5,=0A    6,=0A    4,=0A    5,=0A    4=0A  ],=0A  "slabi=
nfo.TCPv6.active_objs": [=0A    64,=0A    48,=0A    48,=0A    48,=0A    48=
=0A  ],=0A  "slabinfo.TCPv6.num_objs": [=0A    64,=0A    48,=0A    48,=0A  =
  48,=0A    48=0A  ],=0A  "slabinfo.TCPv6.active_slabs": [=0A    4,=0A    3=
,=0A    3,=0A    3,=0A    3=0A  ],=0A  "slabinfo.TCPv6.num_slabs": [=0A    =
4,=0A    3,=0A    3,=0A    3,=0A    3=0A  ],=0A  "slabinfo.mqueue_inode_cac=
he.active_objs": [=0A    36,=0A    36,=0A    36,=0A    36,=0A    36=0A  ],=
=0A  "slabinfo.mqueue_inode_cache.num_objs": [=0A    36,=0A    36,=0A    36=
,=0A    36,=0A    36=0A  ],=0A  "slabinfo.mqueue_inode_cache.active_slabs":=
 [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.mqueue_=
inode_cache.num_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ]=
,=0A  "slabinfo.xfs_buf.active_objs": [=0A    168,=0A    126,=0A    126,=0A=
    168,=0A    168=0A  ],=0A  "slabinfo.xfs_buf.num_objs": [=0A    168,=0A =
   126,=0A    126,=0A    168,=0A    168=0A  ],=0A  "slabinfo.xfs_buf.active=
_slabs": [=0A    4,=0A    3,=0A    3,=0A    4,=0A    4=0A  ],=0A  "slabinfo=
=2Exfs_buf.num_slabs": [=0A    4,=0A    3,=0A    3,=0A    4,=0A    4=0A  ],=
=0A  "slabinfo.nfs_commit_data.active_objs": [=0A    46,=0A    46,=0A    46=
,=0A    46,=0A    46=0A  ],=0A  "slabinfo.nfs_commit_data.num_objs": [=0A  =
  46,=0A    46,=0A    46,=0A    46,=0A    46=0A  ],=0A  "slabinfo.nfs_commi=
t_data.active_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=
=0A  "slabinfo.nfs_commit_data.num_slabs": [=0A    1,=0A    1,=0A    1,=0A =
   1,=0A    1=0A  ],=0A  "slabinfo.nfs_read_data.active_objs": [=0A    170,=
=0A    168,=0A    147,=0A    278,=0A    311=0A  ],=0A  "slabinfo.nfs_read_d=
ata.num_objs": [=0A    170,=0A    168,=0A    147,=0A    278,=0A    311=0A  =
],=0A  "slabinfo.nfs_read_data.active_slabs": [=0A    5,=0A    4,=0A    4,=
=0A    8,=0A    9=0A  ],=0A  "slabinfo.nfs_read_data.num_slabs": [=0A    5,=
=0A    4,=0A    4,=0A    8,=0A    9=0A  ],=0A  "slabinfo.nfs_inode_cache.ac=
tive_objs": [=0A    31,=0A    31,=0A    31,=0A    31,=0A    31=0A  ],=0A  "=
slabinfo.nfs_inode_cache.num_objs": [=0A    31,=0A    31,=0A    31,=0A    3=
1,=0A    31=0A  ],=0A  "slabinfo.nfs_inode_cache.active_slabs": [=0A    1,=
=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.nfs_inode_cache.nu=
m_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinf=
o.hugetlbfs_inode_cache.active_objs": [=0A    54,=0A    54,=0A    54,=0A   =
 54,=0A    54=0A  ],=0A  "slabinfo.hugetlbfs_inode_cache.num_objs": [=0A   =
 54,=0A    54,=0A    54,=0A    54,=0A    54=0A  ],=0A  "slabinfo.hugetlbfs_=
inode_cache.active_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A=
  ],=0A  "slabinfo.hugetlbfs_inode_cache.num_slabs": [=0A    1,=0A    1,=0A=
    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.posix_timers_cache.active_objs=
": [=0A    56,=0A    56,=0A    56,=0A    56,=0A    56=0A  ],=0A  "slabinfo.=
posix_timers_cache.num_objs": [=0A    56,=0A    56,=0A    56,=0A    56,=0A =
   56=0A  ],=0A  "slabinfo.posix_timers_cache.active_slabs": [=0A    0,=0A =
   0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "slabinfo.posix_timers_cache.num=
_slabs": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "slabinfo=
=2Eip_fib_trie.active_objs": [=0A    146,=0A    146,=0A    146,=0A    146,=
=0A    146=0A  ],=0A  "slabinfo.ip_fib_trie.num_objs": [=0A    146,=0A    1=
46,=0A    146,=0A    146,=0A    146=0A  ],=0A  "slabinfo.ip_fib_trie.active=
_slabs": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "slabinfo=
=2Eip_fib_trie.num_slabs": [=0A    2,=0A    2,=0A    2,=0A    2,=0A    2=0A=
  ],=0A  "slabinfo.RAW.active_objs": [=0A    684,=0A    612,=0A    612,=0A =
   684,=0A    576=0A  ],=0A  "slabinfo.RAW.num_objs": [=0A    684,=0A    61=
2,=0A    612,=0A    684,=0A    576=0A  ],=0A  "slabinfo.RAW.active_slabs": =
[=0A    19,=0A    17,=0A    17,=0A    19,=0A    16=0A  ],=0A  "slabinfo.RAW=
=2Enum_slabs": [=0A    19,=0A    17,=0A    17,=0A    19,=0A    16=0A  ],=0A=
  "slabinfo.UDP.active_objs": [=0A    170,=0A    170,=0A    170,=0A    136,=
=0A    170=0A  ],=0A  "slabinfo.UDP.num_objs": [=0A    170,=0A    170,=0A  =
  170,=0A    136,=0A    170=0A  ],=0A  "slabinfo.UDP.active_slabs": [=0A   =
 5,=0A    5,=0A    5,=0A    4,=0A    5=0A  ],=0A  "slabinfo.UDP.num_slabs":=
 [=0A    5,=0A    5,=0A    5,=0A    4,=0A    5=0A  ],=0A  "slabinfo.tw_sock=
_TCP.active_objs": [=0A    64,=0A    64,=0A    64,=0A    64,=0A    64=0A  ]=
,=0A  "slabinfo.tw_sock_TCP.num_objs": [=0A    64,=0A    64,=0A    64,=0A  =
  64,=0A    64=0A  ],=0A  "slabinfo.tw_sock_TCP.active_slabs": [=0A    1,=
=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.tw_sock_TCP.num_sl=
abs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.TC=
P.active_objs": [=0A    119,=0A    102,=0A    136,=0A    119,=0A    136=0A =
 ],=0A  "slabinfo.TCP.num_objs": [=0A    119,=0A    102,=0A    136,=0A    1=
19,=0A    136=0A  ],=0A  "slabinfo.TCP.active_slabs": [=0A    7,=0A    6,=
=0A    8,=0A    7,=0A    8=0A  ],=0A  "slabinfo.TCP.num_slabs": [=0A    7,=
=0A    6,=0A    8,=0A    7,=0A    8=0A  ],=0A  "slabinfo.blkdev_ioc.active_=
objs": [=0A    39,=0A    39,=0A    39,=0A    39,=0A    39=0A  ],=0A  "slabi=
nfo.blkdev_ioc.num_objs": [=0A    39,=0A    39,=0A    39,=0A    39,=0A    3=
9=0A  ],=0A  "slabinfo.blkdev_ioc.active_slabs": [=0A    1,=0A    1,=0A    =
1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.blkdev_ioc.num_slabs": [=0A    1,=
=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.sock_inode_cache.a=
ctive_objs": [=0A    1632,=0A    1377,=0A    1530,=0A    1377,=0A    1377=
=0A  ],=0A  "slabinfo.sock_inode_cache.num_objs": [=0A    1632,=0A    1377,=
=0A    1530,=0A    1377,=0A    1377=0A  ],=0A  "slabinfo.sock_inode_cache.a=
ctive_slabs": [=0A    32,=0A    27,=0A    30,=0A    27,=0A    27=0A  ],=0A =
 "slabinfo.sock_inode_cache.num_slabs": [=0A    32,=0A    27,=0A    30,=0A =
   27,=0A    27=0A  ],=0A  "slabinfo.shmem_inode_cache.active_objs": [=0A  =
  3455,=0A    3743,=0A    3743,=0A    3647,=0A    3242=0A  ],=0A  "slabinfo=
=2Eshmem_inode_cache.num_objs": [=0A    3455,=0A    3743,=0A    3743,=0A   =
 3647,=0A    3264=0A  ],=0A  "slabinfo.shmem_inode_cache.active_slabs": [=
=0A    71,=0A    77,=0A    77,=0A    75,=0A    68=0A  ],=0A  "slabinfo.shme=
m_inode_cache.num_slabs": [=0A    71,=0A    77,=0A    77,=0A    75,=0A    6=
8=0A  ],=0A  "slabinfo.ftrace_event_file.active_objs": [=0A    1518,=0A    =
1518,=0A    1518,=0A    1518,=0A    1518=0A  ],=0A  "slabinfo.ftrace_event_=
file.num_objs": [=0A    1518,=0A    1518,=0A    1518,=0A    1518,=0A    151=
8=0A  ],=0A  "slabinfo.ftrace_event_file.active_slabs": [=0A    33,=0A    3=
3,=0A    33,=0A    33,=0A    33=0A  ],=0A  "slabinfo.ftrace_event_file.num_=
slabs": [=0A    33,=0A    33,=0A    33,=0A    33,=0A    33=0A  ],=0A  "slab=
info.taskstats.active_objs": [=0A    49,=0A    98,=0A    98,=0A    98,=0A  =
  98=0A  ],=0A  "slabinfo.taskstats.num_objs": [=0A    49,=0A    98,=0A    =
98,=0A    98,=0A    98=0A  ],=0A  "slabinfo.taskstats.active_slabs": [=0A  =
  1,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "slabinfo.taskstats.num_=
slabs": [=0A    1,=0A    2,=0A    2,=0A    2,=0A    2=0A  ],=0A  "slabinfo.=
proc_inode_cache.active_objs": [=0A    10043,=0A    10241,=0A    9792,=0A  =
  9730,=0A    9240=0A  ],=0A  "slabinfo.proc_inode_cache.num_objs": [=0A   =
 10043,=0A    10256,=0A    9794,=0A    9930,=0A    9275=0A  ],=0A  "slabinf=
o.proc_inode_cache.active_slabs": [=0A    200,=0A    205,=0A    195,=0A    =
198,=0A    185=0A  ],=0A  "slabinfo.proc_inode_cache.num_slabs": [=0A    20=
0,=0A    205,=0A    195,=0A    198,=0A    185=0A  ],=0A  "slabinfo.sigqueue=
=2Eactive_objs": [=0A    2447,=0A    2448,=0A    2447,=0A    2447,=0A    24=
47=0A  ],=0A  "slabinfo.sigqueue.num_objs": [=0A    2447,=0A    2448,=0A   =
 2447,=0A    2447,=0A    2447=0A  ],=0A  "slabinfo.sigqueue.active_slabs": =
[=0A    47,=0A    48,=0A    47,=0A    47,=0A    47=0A  ],=0A  "slabinfo.sig=
queue.num_slabs": [=0A    47,=0A    48,=0A    47,=0A    47,=0A    47=0A  ],=
=0A  "slabinfo.bdev_cache.active_objs": [=0A    39,=0A    39,=0A    39,=0A =
   39,=0A    39=0A  ],=0A  "slabinfo.bdev_cache.num_objs": [=0A    39,=0A  =
  39,=0A    39,=0A    39,=0A    39=0A  ],=0A  "slabinfo.bdev_cache.active_s=
labs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=0A  "slabinfo.b=
dev_cache.num_slabs": [=0A    1,=0A    1,=0A    1,=0A    1,=0A    1=0A  ],=
=0A  "slabinfo.kernfs_node_cache.active_objs": [=0A    41616,=0A    41684,=
=0A    41888,=0A    41752,=0A    41684=0A  ],=0A  "slabinfo.kernfs_node_cac=
he.num_objs": [=0A    41616,=0A    41684,=0A    41888,=0A    41752,=0A    4=
1684=0A  ],=0A  "slabinfo.kernfs_node_cache.active_slabs": [=0A    612,=0A =
   613,=0A    616,=0A    614,=0A    613=0A  ],=0A  "slabinfo.kernfs_node_ca=
che.num_slabs": [=0A    612,=0A    613,=0A    616,=0A    614,=0A    613=0A =
 ],=0A  "slabinfo.mnt_cache.active_objs": [=0A    408,=0A    306,=0A    306=
,=0A    357,=0A    357=0A  ],=0A  "slabinfo.mnt_cache.num_objs": [=0A    40=
8,=0A    306,=0A    306,=0A    357,=0A    357=0A  ],=0A  "slabinfo.mnt_cach=
e.active_slabs": [=0A    8,=0A    6,=0A    6,=0A    7,=0A    7=0A  ],=0A  "=
slabinfo.mnt_cache.num_slabs": [=0A    8,=0A    6,=0A    6,=0A    7,=0A    =
7=0A  ],=0A  "slabinfo.inode_cache.active_objs": [=0A    51496,=0A    51762=
,=0A    52049,=0A    51704,=0A    51532=0A  ],=0A  "slabinfo.inode_cache.nu=
m_objs": [=0A    51970,=0A    52221,=0A    52517,=0A    52192,=0A    52018=
=0A  ],=0A  "slabinfo.inode_cache.active_slabs": [=0A    928,=0A    932,=0A=
    937,=0A    932,=0A    928=0A  ],=0A  "slabinfo.inode_cache.num_slabs": =
[=0A    928,=0A    932,=0A    937,=0A    932,=0A    928=0A  ],=0A  "slabinf=
o.dentry.active_objs": [=0A    108412,=0A    108781,=0A    110484,=0A    11=
0404,=0A    108449=0A  ],=0A  "slabinfo.dentry.num_objs": [=0A    115952,=
=0A    116511,=0A    118514,=0A    117870,=0A    115892=0A  ],=0A  "slabinf=
o.dentry.active_slabs": [=0A    2760,=0A    2774,=0A    2821,=0A    2806,=
=0A    2759=0A  ],=0A  "slabinfo.dentry.num_slabs": [=0A    2760,=0A    277=
4,=0A    2821,=0A    2806,=0A    2759=0A  ],=0A  "slabinfo.vm_area_struct.a=
ctive_objs": [=0A    25534,=0A    26065,=0A    24963,=0A    22362,=0A    26=
146=0A  ],=0A  "slabinfo.vm_area_struct.num_objs": [=0A    25549,=0A    260=
65,=0A    24965,=0A    22362,=0A    26251=0A  ],=0A  "slabinfo.vm_area_stru=
ct.active_slabs": [=0A    580,=0A    592,=0A    567,=0A    508,=0A    596=
=0A  ],=0A  "slabinfo.vm_area_struct.num_slabs": [=0A    580,=0A    592,=0A=
    567,=0A    508,=0A    596=0A  ],=0A  "slabinfo.mm_struct.active_objs": =
[=0A    1053,=0A    1087,=0A    1031,=0A    968,=0A    1070=0A  ],=0A  "sla=
binfo.mm_struct.num_objs": [=0A    1053,=0A    1087,=0A    1031,=0A    968,=
=0A    1070=0A  ],=0A  "slabinfo.mm_struct.active_slabs": [=0A    61,=0A   =
 63,=0A    60,=0A    56,=0A    62=0A  ],=0A  "slabinfo.mm_struct.num_slabs"=
: [=0A    61,=0A    63,=0A    60,=0A    56,=0A    62=0A  ],=0A  "slabinfo.f=
iles_cache.active_objs": [=0A    2751,=0A    2855,=0A    2802,=0A    2698,=
=0A    2804=0A  ],=0A  "slabinfo.files_cache.num_objs": [=0A    2751,=0A   =
 2855,=0A    2802,=0A    2698,=0A    2804=0A  ],=0A  "slabinfo.files_cache.=
active_slabs": [=0A    53,=0A    55,=0A    54,=0A    52,=0A    54=0A  ],=0A=
  "slabinfo.files_cache.num_slabs": [=0A    53,=0A    55,=0A    54,=0A    5=
2,=0A    54=0A  ],=0A  "slabinfo.signal_cache.active_objs": [=0A    2768,=
=0A    2904,=0A    2731,=0A    2664,=0A    2862=0A  ],=0A  "slabinfo.signal=
_cache.num_objs": [=0A    2828,=0A    2988,=0A    2883,=0A    2713,=0A    2=
939=0A  ],=0A  "slabinfo.signal_cache.active_slabs": [=0A    101,=0A    106=
,=0A    102,=0A    96,=0A    104=0A  ],=0A  "slabinfo.signal_cache.num_slab=
s": [=0A    101,=0A    106,=0A    102,=0A    96,=0A    104=0A  ],=0A  "slab=
info.sighand_cache.active_objs": [=0A    1844,=0A    1920,=0A    1846,=0A  =
  1874,=0A    1905=0A  ],=0A  "slabinfo.sighand_cache.num_objs": [=0A    19=
04,=0A    1979,=0A    1904,=0A    1874,=0A    1979=0A  ],=0A  "slabinfo.sig=
hand_cache.active_slabs": [=0A    126,=0A    131,=0A    126,=0A    124,=0A =
   131=0A  ],=0A  "slabinfo.sighand_cache.num_slabs": [=0A    126,=0A    13=
1,=0A    126,=0A    124,=0A    131=0A  ],=0A  "slabinfo.task_xstate.active_=
objs": [=0A    3430,=0A    3432,=0A    3314,=0A    3350,=0A    3470=0A  ],=
=0A  "slabinfo.task_xstate.num_objs": [=0A    3430,=0A    3432,=0A    3314,=
=0A    3350,=0A    3470=0A  ],=0A  "slabinfo.task_xstate.active_slabs": [=
=0A    87,=0A    88,=0A    84,=0A    85,=0A    88=0A  ],=0A  "slabinfo.task=
_xstate.num_slabs": [=0A    87,=0A    88,=0A    84,=0A    85,=0A    88=0A  =
],=0A  "slabinfo.task_struct.active_objs": [=0A    1431,=0A    1441,=0A    =
1406,=0A    1427,=0A    1440=0A  ],=0A  "slabinfo.task_struct.num_objs": [=
=0A    1447,=0A    1458,=0A    1421,=0A    1444,=0A    1457=0A  ],=0A  "sla=
binfo.task_struct.active_slabs": [=0A    361,=0A    364,=0A    355,=0A    3=
61,=0A    364=0A  ],=0A  "slabinfo.task_struct.num_slabs": [=0A    361,=0A =
   364,=0A    355,=0A    361,=0A    364=0A  ],=0A  "slabinfo.Acpi-ParseExt.=
active_objs": [=0A    141008,=0A    141008,=0A    141008,=0A    141008,=0A =
   141008=0A  ],=0A  "slabinfo.Acpi-ParseExt.num_objs": [=0A    141008,=0A =
   141008,=0A    141008,=0A    141008,=0A    141008=0A  ],=0A  "slabinfo.Ac=
pi-ParseExt.active_slabs": [=0A    2518,=0A    2518,=0A    2518,=0A    2518=
,=0A    2518=0A  ],=0A  "slabinfo.Acpi-ParseExt.num_slabs": [=0A    2518,=
=0A    2518,=0A    2518,=0A    2518,=0A    2518=0A  ],=0A  "slabinfo.Acpi-S=
tate.active_objs": [=0A    67682,=0A    67904,=0A    68257,=0A    67914,=0A=
    67835=0A  ],=0A  "slabinfo.Acpi-State.num_objs": [=0A    67953,=0A    6=
8190,=0A    68546,=0A    68194,=0A    68132=0A  ],=0A  "slabinfo.Acpi-State=
=2Eactive_slabs": [=0A    1332,=0A    1337,=0A    1344,=0A    1337,=0A    1=
335=0A  ],=0A  "slabinfo.Acpi-State.num_slabs": [=0A    1332,=0A    1337,=
=0A    1344,=0A    1337,=0A    1335=0A  ],=0A  "slabinfo.Acpi-Namespace.act=
ive_objs": [=0A    14483,=0A    14367,=0A    14687,=0A    14382,=0A    1448=
3=0A  ],=0A  "slabinfo.Acpi-Namespace.num_objs": [=0A    14483,=0A    14367=
,=0A    14687,=0A    14382,=0A    14483=0A  ],=0A  "slabinfo.Acpi-Namespace=
=2Eactive_slabs": [=0A    141,=0A    140,=0A    143,=0A    141,=0A    141=
=0A  ],=0A  "slabinfo.Acpi-Namespace.num_slabs": [=0A    141,=0A    140,=0A=
    143,=0A    141,=0A    141=0A  ],=0A  "slabinfo.anon_vma.active_objs": [=
=0A    11449,=0A    11527,=0A    10182,=0A    8775,=0A    11169=0A  ],=0A  =
"slabinfo.anon_vma.num_objs": [=0A    11449,=0A    11527,=0A    10182,=0A  =
  8775,=0A    11169=0A  ],=0A  "slabinfo.anon_vma.active_slabs": [=0A    20=
4,=0A    205,=0A    181,=0A    156,=0A    199=0A  ],=0A  "slabinfo.anon_vma=
=2Enum_slabs": [=0A    204,=0A    205,=0A    181,=0A    156,=0A    199=0A  =
],=0A  "slabinfo.shared_policy_node.active_objs": [=0A    6885,=0A    6885,=
=0A    6885,=0A    6885,=0A    6885=0A  ],=0A  "slabinfo.shared_policy_node=
=2Enum_objs": [=0A    6885,=0A    6885,=0A    6885,=0A    6885,=0A    6885=
=0A  ],=0A  "slabinfo.shared_policy_node.active_slabs": [=0A    81,=0A    8=
1,=0A    81,=0A    81,=0A    81=0A  ],=0A  "slabinfo.shared_policy_node.num=
_slabs": [=0A    81,=0A    81,=0A    81,=0A    81,=0A    81=0A  ],=0A  "sla=
binfo.numa_policy.active_objs": [=0A    248,=0A    248,=0A    248,=0A    24=
8,=0A    248=0A  ],=0A  "slabinfo.numa_policy.num_objs": [=0A    248,=0A   =
 248,=0A    248,=0A    248,=0A    248=0A  ],=0A  "slabinfo.numa_policy.acti=
ve_slabs": [=0A    4,=0A    4,=0A    4,=0A    4,=0A    4=0A  ],=0A  "slabin=
fo.numa_policy.num_slabs": [=0A    4,=0A    4,=0A    4,=0A    4,=0A    4=0A=
  ],=0A  "slabinfo.radix_tree_node.active_objs": [=0A    24514,=0A    24546=
,=0A    24524,=0A    24476,=0A    24519=0A  ],=0A  "slabinfo.radix_tree_nod=
e.num_objs": [=0A    24931,=0A    24917,=0A    24892,=0A    24930,=0A    24=
936=0A  ],=0A  "slabinfo.radix_tree_node.active_slabs": [=0A    445,=0A    =
444,=0A    444,=0A    445,=0A    445=0A  ],=0A  "slabinfo.radix_tree_node.n=
um_slabs": [=0A    445,=0A    444,=0A    444,=0A    445,=0A    445=0A  ],=
=0A  "slabinfo.idr_layer_cache.active_objs": [=0A    1530,=0A    1515,=0A  =
  1515,=0A    1515,=0A    1515=0A  ],=0A  "slabinfo.idr_layer_cache.num_obj=
s": [=0A    1530,=0A    1515,=0A    1515,=0A    1515,=0A    1515=0A  ],=0A =
 "slabinfo.idr_layer_cache.active_slabs": [=0A    102,=0A    101,=0A    101=
,=0A    101,=0A    101=0A  ],=0A  "slabinfo.idr_layer_cache.num_slabs": [=
=0A    102,=0A    101,=0A    101,=0A    101,=0A    101=0A  ],=0A  "slabinfo=
=2Ekmalloc-8192.active_objs": [=0A    148,=0A    160,=0A    151,=0A    151,=
=0A    156=0A  ],=0A  "slabinfo.kmalloc-8192.num_objs": [=0A    148,=0A    =
160,=0A    151,=0A    151,=0A    156=0A  ],=0A  "slabinfo.kmalloc-8192.acti=
ve_slabs": [=0A    37,=0A    40,=0A    37,=0A    37,=0A    39=0A  ],=0A  "s=
labinfo.kmalloc-8192.num_slabs": [=0A    37,=0A    40,=0A    37,=0A    37,=
=0A    39=0A  ],=0A  "slabinfo.kmalloc-4096.active_objs": [=0A    659,=0A  =
  659,=0A    636,=0A    674,=0A    645=0A  ],=0A  "slabinfo.kmalloc-4096.nu=
m_objs": [=0A    739,=0A    751,=0A    722,=0A    760,=0A    732=0A  ],=0A =
 "slabinfo.kmalloc-4096.active_slabs": [=0A    92,=0A    93,=0A    90,=0A  =
  95,=0A    91=0A  ],=0A  "slabinfo.kmalloc-4096.num_slabs": [=0A    92,=0A=
    93,=0A    90,=0A    95,=0A    91=0A  ],=0A  "slabinfo.kmalloc-2048.acti=
ve_objs": [=0A    2238,=0A    2307,=0A    2064,=0A    2271,=0A    2161=0A  =
],=0A  "slabinfo.kmalloc-2048.num_objs": [=0A    2384,=0A    2432,=0A    21=
76,=0A    2400,=0A    2272=0A  ],=0A  "slabinfo.kmalloc-2048.active_slabs":=
 [=0A    149,=0A    152,=0A    136,=0A    150,=0A    142=0A  ],=0A  "slabin=
fo.kmalloc-2048.num_slabs": [=0A    149,=0A    152,=0A    136,=0A    150,=
=0A    142=0A  ],=0A  "slabinfo.kmalloc-1024.active_objs": [=0A    4951,=0A=
    4923,=0A    4923,=0A    4891,=0A    4667=0A  ],=0A  "slabinfo.kmalloc-1=
024.num_objs": [=0A    4951,=0A    4923,=0A    4923,=0A    4891,=0A    4800=
=0A  ],=0A  "slabinfo.kmalloc-1024.active_slabs": [=0A    154,=0A    153,=
=0A    153,=0A    152,=0A    150=0A  ],=0A  "slabinfo.kmalloc-1024.num_slab=
s": [=0A    154,=0A    153,=0A    153,=0A    152,=0A    150=0A  ],=0A  "sla=
binfo.kmalloc-512.active_objs": [=0A    9040,=0A    9104,=0A    8977,=0A   =
 9233,=0A    9072=0A  ],=0A  "slabinfo.kmalloc-512.num_objs": [=0A    9088,=
=0A    9152,=0A    9024,=0A    9280,=0A    9088=0A  ],=0A  "slabinfo.kmallo=
c-512.active_slabs": [=0A    142,=0A    143,=0A    141,=0A    145,=0A    14=
2=0A  ],=0A  "slabinfo.kmalloc-512.num_slabs": [=0A    142,=0A    143,=0A  =
  141,=0A    145,=0A    142=0A  ],=0A  "slabinfo.kmalloc-256.active_objs": =
[=0A    92315,=0A    93062,=0A    96046,=0A    95392,=0A    92510=0A  ],=0A=
  "slabinfo.kmalloc-256.num_objs": [=0A    95243,=0A    96091,=0A    99049,=
=0A    98000,=0A    95210=0A  ],=0A  "slabinfo.kmalloc-256.active_slabs": [=
=0A    1488,=0A    1501,=0A    1547,=0A    1531,=0A    1487=0A  ],=0A  "sla=
binfo.kmalloc-256.num_slabs": [=0A    1488,=0A    1501,=0A    1547,=0A    1=
531,=0A    1487=0A  ],=0A  "slabinfo.kmalloc-192.active_objs": [=0A    1145=
8,=0A    12514,=0A    13122,=0A    12023,=0A    13859=0A  ],=0A  "slabinfo.=
kmalloc-192.num_objs": [=0A    11458,=0A    12514,=0A    13122,=0A    12224=
,=0A    13866=0A  ],=0A  "slabinfo.kmalloc-192.active_slabs": [=0A    272,=
=0A    297,=0A    312,=0A    291,=0A    330=0A  ],=0A  "slabinfo.kmalloc-19=
2.num_slabs": [=0A    272,=0A    297,=0A    312,=0A    291,=0A    330=0A  ]=
,=0A  "slabinfo.kmalloc-128.active_objs": [=0A    5989,=0A    5933,=0A    5=
806,=0A    5807,=0A    5806=0A  ],=0A  "slabinfo.kmalloc-128.num_objs": [=
=0A    6044,=0A    5987,=0A    5860,=0A    5861,=0A    5861=0A  ],=0A  "sla=
binfo.kmalloc-128.active_slabs": [=0A    94,=0A    93,=0A    91,=0A    91,=
=0A    91=0A  ],=0A  "slabinfo.kmalloc-128.num_slabs": [=0A    94,=0A    93=
,=0A    91,=0A    91,=0A    91=0A  ],=0A  "slabinfo.kmalloc-96.active_objs"=
: [=0A    3738,=0A    3780,=0A    3486,=0A    3738,=0A    3864=0A  ],=0A  "=
slabinfo.kmalloc-96.num_objs": [=0A    3780,=0A    3822,=0A    3612,=0A    =
3780,=0A    3906=0A  ],=0A  "slabinfo.kmalloc-96.active_slabs": [=0A    90,=
=0A    91,=0A    86,=0A    90,=0A    93=0A  ],=0A  "slabinfo.kmalloc-96.num=
_slabs": [=0A    90,=0A    91,=0A    86,=0A    90,=0A    93=0A  ],=0A  "sla=
binfo.kmalloc-64.active_objs": [=0A    64735,=0A    67493,=0A    67821,=0A =
   65170,=0A    68395=0A  ],=0A  "slabinfo.kmalloc-64.num_objs": [=0A    64=
955,=0A    67493,=0A    67823,=0A    65170,=0A    68398=0A  ],=0A  "slabinf=
o.kmalloc-64.active_slabs": [=0A    1014,=0A    1054,=0A    1059,=0A    101=
8,=0A    1068=0A  ],=0A  "slabinfo.kmalloc-64.num_slabs": [=0A    1014,=0A =
   1054,=0A    1059,=0A    1018,=0A    1068=0A  ],=0A  "slabinfo.kmalloc-32=
=2Eactive_objs": [=0A    31212,=0A    31104,=0A    31232,=0A    30590,=0A  =
  31359=0A  ],=0A  "slabinfo.kmalloc-32.num_objs": [=0A    31212,=0A    311=
04,=0A    31232,=0A    30590,=0A    31359=0A  ],=0A  "slabinfo.kmalloc-32.a=
ctive_slabs": [=0A    243,=0A    243,=0A    244,=0A    238,=0A    244=0A  ]=
,=0A  "slabinfo.kmalloc-32.num_slabs": [=0A    243,=0A    243,=0A    244,=
=0A    238,=0A    244=0A  ],=0A  "slabinfo.kmalloc-16.active_objs": [=0A   =
 19074,=0A    19447,=0A    19198,=0A    19197,=0A    18937=0A  ],=0A  "slab=
info.kmalloc-16.num_objs": [=0A    19074,=0A    19447,=0A    19199,=0A    1=
9197,=0A    18937=0A  ],=0A  "slabinfo.kmalloc-16.active_slabs": [=0A    74=
,=0A    75,=0A    74,=0A    74,=0A    73=0A  ],=0A  "slabinfo.kmalloc-16.nu=
m_slabs": [=0A    74,=0A    75,=0A    74,=0A    74,=0A    73=0A  ],=0A  "sl=
abinfo.kmalloc-8.active_objs": [=0A    30208,=0A    30208,=0A    30208,=0A =
   30208,=0A    30208=0A  ],=0A  "slabinfo.kmalloc-8.num_objs": [=0A    302=
08,=0A    30208,=0A    30208,=0A    30208,=0A    30208=0A  ],=0A  "slabinfo=
=2Ekmalloc-8.active_slabs": [=0A    59,=0A    59,=0A    59,=0A    59,=0A   =
 59=0A  ],=0A  "slabinfo.kmalloc-8.num_slabs": [=0A    59,=0A    59,=0A    =
59,=0A    59,=0A    59=0A  ],=0A  "slabinfo.kmem_cache_node.active_objs": [=
=0A    431,=0A    495,=0A    559,=0A    431,=0A    751=0A  ],=0A  "slabinfo=
=2Ekmem_cache_node.num_objs": [=0A    448,=0A    512,=0A    576,=0A    448,=
=0A    768=0A  ],=0A  "slabinfo.kmem_cache_node.active_slabs": [=0A    7,=
=0A    8,=0A    9,=0A    7,=0A    12=0A  ],=0A  "slabinfo.kmem_cache_node.n=
um_slabs": [=0A    7,=0A    8,=0A    9,=0A    7,=0A    12=0A  ],=0A  "slabi=
nfo.kmem_cache.active_objs": [=0A    320,=0A    384,=0A    448,=0A    320,=
=0A    640=0A  ],=0A  "slabinfo.kmem_cache.num_objs": [=0A    320,=0A    38=
4,=0A    448,=0A    320,=0A    640=0A  ],=0A  "slabinfo.kmem_cache.active_s=
labs": [=0A    5,=0A    6,=0A    7,=0A    5,=0A    10=0A  ],=0A  "slabinfo.=
kmem_cache.num_slabs": [=0A    5,=0A    6,=0A    7,=0A    5,=0A    10=0A  ]=
,=0A  "numa-meminfo.node0.MemTotal": [=0A    32853760,=0A    32853760,=0A  =
  32853760,=0A    32853760,=0A    32853760=0A  ],=0A  "numa-meminfo.node0.M=
emFree": [=0A    31688105,=0A    31517987,=0A    31737588,=0A    31509355,=
=0A    31490867=0A  ],=0A  "numa-meminfo.node0.MemUsed": [=0A    1165654,=
=0A    1335772,=0A    1116171,=0A    1344404,=0A    1362892=0A  ],=0A  "num=
a-meminfo.node0.Active": [=0A    175776,=0A    370346,=0A    170539,=0A    =
372167,=0A    374241=0A  ],=0A  "numa-meminfo.node0.Inactive": [=0A    6169=
28,=0A    592735,=0A    578643,=0A    594336,=0A    614274=0A  ],=0A  "numa=
-meminfo.node0.Active(anon)": [=0A    18978,=0A    220496,=0A    24153,=0A =
   222789,=0A    217438=0A  ],=0A  "numa-meminfo.node0.Inactive(anon)": [=
=0A    153,=0A    1918,=0A    164,=0A    1518,=0A    1817=0A  ],=0A  "numa-=
meminfo.node0.Active(file)": [=0A    156797,=0A    149849,=0A    146386,=0A=
    149377,=0A    156802=0A  ],=0A  "numa-meminfo.node0.Inactive(file)": [=
=0A    616775,=0A    590816,=0A    578479,=0A    592816,=0A    612457=0A  ]=
,=0A  "numa-meminfo.node0.Dirty": [=0A    2,=0A    4,=0A    4,=0A    1,=0A =
   8=0A  ],=0A  "numa-meminfo.node0.Writeback": [=0A    0,=0A    0,=0A    0=
=0A  ],=0A  "numa-meminfo.node0.FilePages": [=0A    773747,=0A    944550,=
=0A    726176,=0A    944289,=0A    969799=0A  ],=0A  "numa-meminfo.node0.Ma=
pped": [=0A    5609,=0A    6007,=0A    5688,=0A    5637,=0A    5865=0A  ],=
=0A  "numa-meminfo.node0.AnonPages": [=0A    18716,=0A    18977,=0A    2389=
1,=0A    22528,=0A    18563=0A  ],=0A  "numa-meminfo.node0.Shmem": [=0A    =
413,=0A    203441,=0A    426,=0A    201786,=0A    200699=0A  ],=0A  "numa-m=
eminfo.node0.KernelStack": [=0A    14790,=0A    14867,=0A    14929,=0A    1=
4787,=0A    14663=0A  ],=0A  "numa-meminfo.node0.PageTables": [=0A    1518,=
=0A    1565,=0A    1831,=0A    1718,=0A    1679=0A  ],=0A  "numa-meminfo.no=
de0.Slab": [=0A    102179,=0A    101090,=0A    101149,=0A    107789,=0A    =
101758=0A  ],=0A  "numa-meminfo.node0.SReclaimable": [=0A    37324,=0A    3=
7193,=0A    36404,=0A    44178,=0A    39033=0A  ],=0A  "numa-meminfo.node0.=
SUnreclaim": [=0A    64854,=0A    63897,=0A    64745,=0A    63611,=0A    62=
725=0A  ],=0A  "numa-meminfo.node1.MemTotal": [=0A    33015508,=0A    33015=
508,=0A    33015508,=0A    33015508,=0A    33015508=0A  ],=0A  "numa-meminf=
o.node1.MemFree": [=0A    31769986,=0A    31937564,=0A    31726517,=0A    3=
1949411,=0A    31966180=0A  ],=0A  "numa-meminfo.node1.MemUsed": [=0A    12=
45521,=0A    1077943,=0A    1288990,=0A    1066096,=0A    1049327=0A  ],=0A=
  "numa-meminfo.node1.Active": [=0A    358412,=0A    167511,=0A    367720,=
=0A    164020,=0A    160274=0A  ],=0A  "numa-meminfo.node1.Inactive": [=0A =
   568137,=0A    590535,=0A    603933,=0A    588902,=0A    571296=0A  ],=0A=
  "numa-meminfo.node1.Active(anon)": [=0A    213990,=0A    15756,=0A    213=
260,=0A    11868,=0A    16005=0A  ],=0A  "numa-meminfo.node1.Inactive(anon)=
": [=0A    4320,=0A    2921,=0A    4637,=0A    2924,=0A    2928=0A  ],=0A  =
"numa-meminfo.node1.Active(file)": [=0A    144421,=0A    151754,=0A    1544=
60,=0A    152151,=0A    144269=0A  ],=0A  "numa-meminfo.node1.Inactive(file=
)": [=0A    563816,=0A    587613,=0A    599294,=0A    585977,=0A    568367=
=0A  ],=0A  "numa-meminfo.node1.Dirty": [=0A    12,=0A    9,=0A    9,=0A   =
 12,=0A    6=0A  ],=0A  "numa-meminfo.node1.Writeback": [=0A    0,=0A    0,=
=0A    0=0A  ],=0A  "numa-meminfo.node1.FilePages": [=0A    911022,=0A    7=
43017,=0A    962201,=0A    741629,=0A    716006=0A  ],=0A  "numa-meminfo.no=
de1.Mapped": [=0A    5637,=0A    5730,=0A    5977,=0A    5704,=0A    5744=
=0A  ],=0A  "numa-meminfo.node1.AnonPages": [=0A    15547,=0A    15406,=0A =
   9859,=0A    11494,=0A    15652=0A  ],=0A  "numa-meminfo.node1.Shmem": [=
=0A    202767,=0A    3273,=0A    208039,=0A    3299,=0A    3284=0A  ],=0A  =
"numa-meminfo.node1.KernelStack": [=0A    3232,=0A    3150,=0A    3087,=0A =
   3229,=0A    3358=0A  ],=0A  "numa-meminfo.node1.PageTables": [=0A    272=
3,=0A    2634,=0A    2596,=0A    2899,=0A    2535=0A  ],=0A  "numa-meminfo.=
node1.Slab": [=0A    84892,=0A    87712,=0A    87222,=0A    79062,=0A    86=
007=0A  ],=0A  "numa-meminfo.node1.SReclaimable": [=0A    37006,=0A    3739=
7,=0A    38501,=0A    30255,=0A    34930=0A  ],=0A  "numa-meminfo.node1.SUn=
reclaim": [=0A    47885,=0A    50314,=0A    48720,=0A    48807,=0A    51077=
=0A  ],=0A  "numa-meminfo.node1.AnonHugePages": [=0A    4064,=0A    2018,=
=0A    0,=0A    0,=0A    2018=0A  ],=0A  "numa-vmstat.node0.nr_free_pages":=
 [=0A    7922055,=0A    7879559,=0A    7934481,=0A    7877369,=0A    787287=
9=0A  ],=0A  "numa-vmstat.node0.nr_alloc_batch": [=0A    1970,=0A    1862,=
=0A    1844,=0A    1846,=0A    1976=0A  ],=0A  "numa-vmstat.node0.nr_inacti=
ve_anon": [=0A    38,=0A    440,=0A    41,=0A    432,=0A    395=0A  ],=0A  =
"numa-vmstat.node0.nr_active_anon": [=0A    4744,=0A    55115,=0A    6038,=
=0A    55629,=0A    54447=0A  ],=0A  "numa-vmstat.node0.nr_inactive_file": =
[=0A    154170,=0A    147680,=0A    144578,=0A    148172,=0A    152978=0A  =
],=0A  "numa-vmstat.node0.nr_active_file": [=0A    39209,=0A    37497,=0A  =
  36600,=0A    37311,=0A    39166=0A  ],=0A  "numa-vmstat.node0.nr_anon_pag=
es": [=0A    4678,=0A    4744,=0A    5972,=0A    5634,=0A    4638=0A  ],=0A=
  "numa-vmstat.node0.nr_mapped": [=0A    1402,=0A    1446,=0A    1421,=0A  =
  1501,=0A    1426=0A  ],=0A  "numa-vmstat.node0.nr_file_pages": [=0A    19=
3415,=0A    236077,=0A    181489,=0A    235964,=0A    242320=0A  ],=0A  "nu=
ma-vmstat.node0.nr_dirty": [=0A    0,=0A    1,=0A    1,=0A    0,=0A    2=0A=
  ],=0A  "numa-vmstat.node0.nr_writeback": [=0A    0,=0A    0,=0A    0=0A  =
],=0A  "numa-vmstat.node0.nr_slab_reclaimable": [=0A    9344,=0A    9297,=
=0A    9092,=0A    11052,=0A    9768=0A  ],=0A  "numa-vmstat.node0.nr_slab_=
unreclaimable": [=0A    16210,=0A    15971,=0A    16145,=0A    15905,=0A   =
 15701=0A  ],=0A  "numa-vmstat.node0.nr_page_table_pages": [=0A    378,=0A =
   390,=0A    458,=0A    430,=0A    420=0A  ],=0A  "numa-vmstat.node0.nr_ke=
rnel_stack": [=0A    924,=0A    929,=0A    933,=0A    924,=0A    916=0A  ],=
=0A  "numa-vmstat.node0.nr_shmem": [=0A    103,=0A    50813,=0A    106,=0A =
   50429,=0A    50205=0A  ],=0A  "numa-vmstat.node0.nr_dirtied": [=0A    59=
,=0A    57,=0A    63,=0A    57,=0A    90=0A  ],=0A  "numa-vmstat.node0.nr_w=
ritten": [=0A    58,=0A    56,=0A    62,=0A    57,=0A    88=0A  ],=0A  "num=
a-vmstat.node0.numa_hit": [=0A    233996872,=0A    238373181,=0A    2432707=
35,=0A    239361030,=0A    236709005=0A  ],=0A  "numa-vmstat.node0.numa_int=
erleave": [=0A    71199,=0A    70793,=0A    70698,=0A    70981,=0A    70628=
=0A  ],=0A  "numa-vmstat.node0.numa_local": [=0A    233928790,=0A    238311=
183,=0A    243201848,=0A    239298541,=0A    236704909=0A  ],=0A  "numa-vms=
tat.node0.numa_other": [=0A    68082,=0A    61998,=0A    68888,=0A    62488=
,=0A    4096=0A  ],=0A  "numa-vmstat.node1.nr_free_pages": [=0A    7942755,=
=0A    7984345,=0A    7931525,=0A    7987311,=0A    7991510=0A  ],=0A  "num=
a-vmstat.node1.nr_alloc_batch": [=0A    1681,=0A    1629,=0A    1683,=0A   =
 1637,=0A    1526=0A  ],=0A  "numa-vmstat.node1.nr_inactive_anon": [=0A    =
1076,=0A    730,=0A    1158,=0A    731,=0A    732=0A  ],=0A  "numa-vmstat.n=
ode1.nr_active_anon": [=0A    53482,=0A    3938,=0A    53301,=0A    2965,=
=0A    4000=0A  ],=0A  "numa-vmstat.node1.nr_inactive_file": [=0A    140800=
,=0A    146933,=0A    149947,=0A    146546,=0A    142115=0A  ],=0A  "numa-v=
mstat.node1.nr_active_file": [=0A    36089,=0A    37946,=0A    38655,=0A   =
 38029,=0A    36048=0A  ],=0A  "numa-vmstat.node1.nr_anon_pages": [=0A    3=
886,=0A    3850,=0A    2464,=0A    2872,=0A    3912=0A  ],=0A  "numa-vmstat=
=2Enode1.nr_mapped": [=0A    1409,=0A    1423,=0A    1494,=0A    1433,=0A  =
  1427=0A  ],=0A  "numa-vmstat.node1.nr_file_pages": [=0A    227533,=0A    =
185752,=0A    240698,=0A    185448,=0A    179009=0A  ],=0A  "numa-vmstat.no=
de1.nr_dirty": [=0A    3,=0A    2,=0A    2,=0A    3,=0A    1=0A  ],=0A  "nu=
ma-vmstat.node1.nr_writeback": [=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=
=0A  "numa-vmstat.node1.nr_slab_reclaimable": [=0A    9242,=0A    9338,=0A =
   9619,=0A    7563,=0A    8728=0A  ],=0A  "numa-vmstat.node1.nr_slab_unrec=
laimable": [=0A    11972,=0A    12609,=0A    12183,=0A    12211,=0A    1278=
0=0A  ],=0A  "numa-vmstat.node1.nr_page_table_pages": [=0A    680,=0A    65=
8,=0A    649,=0A    724,=0A    633=0A  ],=0A  "numa-vmstat.node1.nr_kernel_=
stack": [=0A    202,=0A    196,=0A    192,=0A    201,=0A    209=0A  ],=0A  =
"numa-vmstat.node1.nr_isolated_anon": [=0A    0,=0A    0,=0A    0,=0A    0,=
=0A    0=0A  ],=0A  "numa-vmstat.node1.nr_shmem": [=0A    50674,=0A    818,=
=0A    51996,=0A    824,=0A    821=0A  ],=0A  "numa-vmstat.node1.nr_dirtied=
": [=0A    83,=0A    83,=0A    76,=0A    84,=0A    51=0A  ],=0A  "numa-vmst=
at.node1.nr_written": [=0A    79,=0A    81,=0A    74,=0A    81,=0A    50=0A=
  ],=0A  "numa-vmstat.node1.numa_hit": [=0A    225890601,=0A    220868506,=
=0A    222641710,=0A    225319846,=0A    227199507=0A  ],=0A  "numa-vmstat.=
node1.numa_interleave": [=0A    75565,=0A    75993,=0A    75933,=0A    7574=
7,=0A    76137=0A  ],=0A  "numa-vmstat.node1.numa_local": [=0A    225875318=
,=0A    220847617,=0A    222627682,=0A    225298902,=0A    227120283=0A  ],=
=0A  "numa-vmstat.node1.numa_other": [=0A    15283,=0A    20888,=0A    1402=
8,=0A    20944,=0A    79224=0A  ],=0A  "numa-vmstat.node1.nr_anon_transpare=
nt_hugepages": [=0A    1,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "st=
ats_source": [=0A    "/result/ivb44/dbench/100%/x86_64-rhel/bb0b6dffa2ccfbd=
9747ad0cc87c7459622896e60/0/stats.json",=0A    "/result/ivb44/dbench/100%/x=
86_64-rhel/bb0b6dffa2ccfbd9747ad0cc87c7459622896e60/1/stats.json",=0A    "/=
result/ivb44/dbench/100%/x86_64-rhel/bb0b6dffa2ccfbd9747ad0cc87c7459622896e=
60/2/stats.json",=0A    "/result/ivb44/dbench/100%/x86_64-rhel/bb0b6dffa2cc=
fbd9747ad0cc87c7459622896e60/3/stats.json",=0A    "/result/ivb44/dbench/100=
%/x86_64-rhel/bb0b6dffa2ccfbd9747ad0cc87c7459622896e60/4/stats.json"=0A  ],=
=0A  "softirqs.CPU20.NET_TX": [=0A    0,=0A    1=0A  ],=0A  "softirqs.CPU5.=
TASKLET": [=0A    0,=0A    1,=0A    1,=0A    0,=0A    2=0A  ],=0A  "softirq=
s.CPU9.TASKLET": [=0A    0,=0A    2,=0A    3,=0A    0,=0A    1=0A  ],=0A  "=
softirqs.CPU10.TASKLET": [=0A    0,=0A    2,=0A    1,=0A    0,=0A    2=0A  =
],=0A  "softirqs.CPU11.TASKLET": [=0A    0,=0A    4,=0A    1,=0A    0,=0A  =
  1=0A  ],=0A  "softirqs.CPU29.TASKLET": [=0A    0,=0A    1,=0A    2=0A  ],=
=0A  "softirqs.CPU30.TASKLET": [=0A    0,=0A    1=0A  ],=0A  "perf-profile.=
cpu-cycles.__list_del_entry.evict.iput.do_unlinkat.sys_unlink": [=0A    0,=
=0A    0.05=0A  ],=0A  "perf-profile.cpu-cycles.address_space_init_once.ino=
de_init_once.init_once.new_slab.__slab_alloc": [=0A    0,=0A    0.02=0A  ],=
=0A  "perf-profile.cpu-cycles.sys_open.open64": [=0A    0,=0A    0.02,=0A  =
  0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__call_rcu.__fput.__=
__fput.task_work_run.do_notify_resume": [=0A    0,=0A    0.02,=0A    0.02,=
=0A    0.02,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.mem_cgroup_unch=
arge_end.truncate_inode_pages_range.truncate_inode_pages_final.evict.iput":=
 [=0A    0,=0A    0.02,=0A    0,=0A    0.02,=0A    0.02=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.vfs_fstat.sys_newfstat.system_call_fastpath.__fxstat64": [=
=0A    0,=0A    0.01,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-prof=
ile.cpu-cycles.mem_cgroup_charge_statistics.isra.20.mem_cgroup_charge_file.=
__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page": [=0A =
   0,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profi=
le.cpu-cycles.finish_open.path_openat.do_filp_open.do_sys_open.sys_openat":=
 [=0A    0,=0A    0.01,=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.open_check_o_direct.path_openat.do_filp_open.do_sys_open.s=
ys_open": [=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profi=
le.cpu-cycles.final_putname.putname.do_sys_open.sys_open.system_call_fastpa=
th": [=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.lockref_get_not_dead.lookup_fast.path_lookupat.filename_looku=
p.user_path_at_empty": [=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-c=
ycles.path_get.do_dentry_open.finish_open.do_last.path_openat": [=0A    0,=
=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cp=
u-cycles.lookup_real.lookup_slow.path_lookupat.filename_lookup.user_path_at=
_empty": [=0A    0,=0A    0.01,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "pe=
rf-profile.cpu-cycles.ret_from_sys_call.__xstat64": [=0A    0,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.path_put.vfs_fstatat.SYSC_newstat.sys_=
newstat.system_call_fastpath": [=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A =
 "perf-profile.cpu-cycles.__mark_inode_dirty.update_time.touch_atime.iterat=
e_dir.sys_getdents": [=0A    0,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-pro=
file.cpu-cycles._cond_resched.____fput.task_work_run.do_notify_resume.int_s=
ignal": [=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mark_page=
_accessed.new_sync_read.vfs_read.sys_pread64.system_call_fastpath": [=0A   =
 0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.=
try_module_get.finish_open.do_last.path_openat.do_filp_open": [=0A    0,=0A=
    0.01=0A  ],=0A  "perf-profile.cpu-cycles.lookup_dcache.do_last.path_ope=
nat.do_filp_open.do_sys_open": [=0A    0,=0A    0.01=0A  ],=0A  "perf-profi=
le.cpu-cycles.kill@plt": [=0A    0,=0A    0.01,=0A    0.01,=0A    0.01,=0A =
   0.01=0A  ],=0A  "perf-profile.cpu-cycles.x86_pmu_disable.perf_adjust_fre=
q_unthr_context.perf_event_task_tick.scheduler_tick.update_process_times": =
[=0A    0,=0A    0.01,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "memin=
fo.Writeback": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0=0A  ],=0A  "nu=
ma-meminfo.node0.AnonHugePages": [=0A    0,=0A    29,=0A    4037,=0A    403=
7,=0A    32=0A  ],=0A  "numa-vmstat.node0.nr_anon_transparent_hugepages": [=
=0A    0,=0A    0,=0A    1,=0A    1,=0A    0=0A  ],=0A  "softirqs.CPU1.NET_=
TX": [=0A    0,=0A    0,=0A    1,=0A    0,=0A    1=0A  ],=0A  "softirqs.CPU=
6.TASKLET": [=0A    0,=0A    0,=0A    2,=0A    0,=0A    2=0A  ],=0A  "softi=
rqs.CPU8.TASKLET": [=0A    0,=0A    0,=0A    2,=0A    0,=0A    3=0A  ],=0A =
 "perf-profile.cpu-cycles.__list_del_entry.list_del.__dentry_kill.dput.dcac=
he_dir_close": [=0A    0,=0A    0,=0A    0.02=0A  ],=0A  "perf-profile.cpu-=
cycles.integrity_iint_find.__fput.____fput.task_work_run.do_notify_resume":=
 [=0A    0,=0A    0,=0A    0.02,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.security_d_instantiate.d_instantiate.simple_lookup.lookup_=
real.__lookup_hash": [=0A    0,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A=
  ],=0A  "perf-profile.cpu-cycles.security_inode_permission.inode_permissio=
n.may_open.do_last.path_openat": [=0A    0,=0A    0,=0A    0.01,=0A    0.01=
,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.inode_has_perm.isra.32.sec=
urity_file_open.do_dentry_open.finish_open.do_last": [=0A    0,=0A    0,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mntput.path_openat=
=2Edo_filp_open.do_sys_open.sys_openat": [=0A    0,=0A    0,=0A    0.01,=0A=
    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.touch_atime.generi=
c_file_read_iter.new_sync_read.vfs_read.sys_read": [=0A    0,=0A    0,=0A  =
  0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__percpu_co=
unter_add.__sb_start_write.mnt_want_write.do_last.path_openat": [=0A    0,=
=0A    0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-c=
ycles._cond_resched.getname_flags.user_path_at_empty.user_path_at.vfs_fstat=
at": [=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.mnt=
_want_write.path_openat.do_filp_open.do_sys_open.sys_open": [=0A    0,=0A  =
  0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.security_compute_sid.se=
curity_transition_sid.may_create.selinux_inode_create.security_inode_create=
": [=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.vfs_g=
etattr.vfs_fstatat.SYSC_newstat.sys_newstat.system_call_fastpath": [=0A    =
0,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cy=
cles.vfs_getattr.vfs_fstat.SYSC_newfstat.sys_newfstat.system_call_fastpath"=
: [=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__clos=
e_fd.system_call_fastpath.close": [=0A    0,=0A    0,=0A    0.01=0A  ],=0A =
 "perf-profile.cpu-cycles.__dentry_kill.dput.do_unlinkat.sys_unlink.system_=
call_fastpath": [=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu=
-cycles.from_kuid_munged.SYSC_newfstat.sys_newfstat.system_call_fastpath.__=
fxstat64": [=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycl=
es.putname.sys_openat.system_call_fastpath": [=0A    0,=0A    0,=0A    0.01=
,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.strncpy_from_user=
=2Egetname.do_sys_open.sys_open.system_call_fastpath": [=0A    0,=0A    0,=
=0A    0.01,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.__percpu_counte=
r_add.path_openat.do_filp_open.do_sys_open.sys_open": [=0A    0,=0A    0,=
=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.dput.path_openat.do_filp_op=
en.do_sys_open.sys_open": [=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-p=
rofile.cpu-cycles.lru_cache_add.pagecache_get_page.grab_cache_page_write_be=
gin.simple_write_begin.generic_perform_write": [=0A    0,=0A    0,=0A    0.=
01=0A  ],=0A  "perf-profile.cpu-cycles.__strdup@plt": [=0A    0,=0A    0,=
=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.make_k=
gid.alloc_inode.new_inode_pseudo.new_inode.ramfs_get_inode": [=0A    0,=0A =
   0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles._IO_default_uflow": [=
=0A    0,=0A    0,=0A    0.01,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.__fxstat@plt": [=0A    0,=0A    0,=0A    0.01,=0A    0.01,=0A=
    0.01=0A  ],=0A  "perf-profile.cpu-cycles._IO_file_read": [=0A    0,=0A =
   0,=0A    0.01,=0A    0.01,=0A    0.01=0A  ],=0A  "softirqs.CPU15.NET_TX"=
: [=0A    0,=0A    0,=0A    0,=0A    1=0A  ],=0A  "softirqs.CPU45.TASKLET":=
 [=0A    0,=0A    0,=0A    0,=0A    1=0A  ],=0A  "perf-profile.cpu-cycles.a=
vc_has_perm.may_create.selinux_inode_create.security_inode_create.vfs_creat=
e": [=0A    0,=0A    0,=0A    0,=0A    0.04,=0A    0.04=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.clear_inode.evict.iput.do_unlinkat.sys_unlink": [=0A    0,=
=0A    0,=0A    0,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.__call_rc=
u.dentry_free.__dentry_kill.dput.terminate_walk": [=0A    0,=0A    0,=0A   =
 0,=0A    0.02=0A  ],=0A  "perf-profile.cpu-cycles.task_work_run.int_signal=
=2Eclose": [=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile=
=2Ecpu-cycles.cmpxchg_double_slab.isra.51.__slab_free.kmem_cache_free.inode=
_free_rcu.rcu_nocb_kthread": [=0A    0,=0A    0,=0A    0,=0A    0.01,=0A   =
 0.02=0A  ],=0A  "perf-profile.cpu-cycles.__inc_zone_page_state.__add_to_pa=
ge_cache_locked.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_wr=
ite_begin": [=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profil=
e.cpu-cycles.__fd_install.do_sys_open.sys_open.system_call_fastpath.open64"=
: [=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycl=
es.__lru_cache_add.add_to_page_cache_lru.pagecache_get_page.grab_cache_page=
_write_begin.simple_write_begin": [=0A    0,=0A    0,=0A    0,=0A    0.01=
=0A  ],=0A  "perf-profile.cpu-cycles.native_write_msr_safe.intel_pmu_disabl=
e_all.x86_pmu_disable.perf_pmu_disable.perf_adjust_freq_unthr_context": [=
=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.=
__list_add.d_alloc.lookup_dcache.do_last.path_openat": [=0A    0,=0A    0,=
=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.map_id_up.from_kui=
d_munged.cp_new_stat.SYSC_newfstat.sys_newfstat": [=0A    0,=0A    0,=0A   =
 0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles.radix_tree_node_ctor.new=
_slab.__slab_alloc.kmem_cache_alloc.__radix_tree_preload": [=0A    0,=0A   =
 0,=0A    0,=0A    0.01=0A  ],=0A  "softirqs.CPU28.TASKLET": [=0A    0,=0A =
   0,=0A    0,=0A    0,=0A    2=0A  ],=0A  "perf-profile.cpu-cycles.__wake_=
up_bit.simple_write_end.generic_perform_write.__generic_file_write_iter.gen=
eric_file_write_iter": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.01=0A =
 ],=0A  "perf-profile.cpu-cycles.should_remove_suid.__generic_file_write_it=
er.generic_file_write_iter.new_sync_write.vfs_write": [=0A    0,=0A    0,=
=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.cpu-cycles._raw_spin=
_unlock_irqrestore.release_pages.__pagevec_release.truncate_inode_pages_ran=
ge.truncate_inode_pages_final": [=0A    0,=0A    0,=0A    0,=0A    0,=0A   =
 0.01=0A  ],=0A  "perf-profile.cpu-cycles.get_pfnblock_flags_mask.free_hot_=
cold_page_list.release_pages.__pagevec_release.truncate_inode_pages_range":=
 [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-profile.=
cpu-cycles.__call_rcu_nocb_enqueue.call_rcu_sched.__fput.____fput.task_work=
_run": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ],=0A  "perf-pr=
ofile.cpu-cycles.inode_init_once.init_once.new_slab.__slab_alloc.kmem_cache=
_alloc": [=0A    0,=0A    0,=0A    0,=0A    0,=0A    0.01=0A  ]=0A}
--pWyiEgJYm5f9v55/--
