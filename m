Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3EVOpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:45:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49327 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3EVOpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:45:10 -0400
X-AuditID: cbfee61a-b7efb6d000003eed-bf-519cd9f4c352
Date: Wed, 22 May 2013 16:44:53 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130522164453.29cd3a7d@amdc308.digital.local>
In-reply-to: <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
 <20130522122700.104ca5cd@amdc308.digital.local>
 <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: multipart/mixed; boundary="MP_/1.Do/nwES91iYxHNqTqzEVd"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jQd0vN+cEGqydJGDxtOkHu8W8z7IW
	nWefMFu8ecRtcXnXHDaLz71HGC1uN65gs+hf2Mtk0XHkG7PFxq8eDlwed67tYfNYN+0ts0ff
	llWMHo8WtzB6fN4kF8AaxWWTkpqTWZZapG+XwJVx+NAh1oI3xhWzrzQyNjDu0e1i5OSQEDCR
	WPvyCjOELSZx4d56NhBbSGA6o8SUn95djFxAdjuTxL/9jWAJFgFVid9XGhhBbDYBPYnPd58y
	dTFycIgIaEm8vJkKUs8scIFJ4tSlWUwgNcIC6RL/tnWB2bwC1hJH/qwCszkFgiUOn7/EDLGg
	g0liwaJesKH8ApIS7f9+QF1kJ3Hu0wZ2iGZBiR+T77GA2MwCrhLHlrxim8AoMAtJahaSFISt
	JfHw1y2ouLzE9rdzmGcB3cosIC2x/B8HRNhU4vLMH0wQtqLElO6H7BC2kcSZRwtZFjByrGIU
	TS1ILihOSs811CtOzC0uzUvXS87P3cQIjrpnUjsYVzZYHGIU4GBU4uF9UDs7UIg1say4MvcQ
	owrQnEcbVl9glGLJy89LVRLhvXppTqAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJ
	JanZqakFqUUwWSYOTqkGxsWCm35VrJ08P01oydrco3MjwyY5zfrbmnVF8CbvDPd1GdeEQl4W
	zhBgvLh1s2ZJueXV4nd+gqm3nSZ/yvS/3l75a4priY9gk7ASr9nt2xEJ698yFJv0Tqi99VmK
	5WDcp5gnUaoMpScfuYaddr4YqbLrsXj7ioc78ib8n35NvN53bmBBS/aGQCWW4oxEQy3mouJE
	ANaUqe7CAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/1.Do/nwES91iYxHNqTqzEVd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Viresh,

> On 22 May 2013 15:57, Lukasz Majewski <l.majewski@samsung.com> wrote:
> >> On 3 May 2013 19:37, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> 
> > I think, that overclocking support is crucial here. As you pointed
> > out
> > - ondemand and conservative benefit from it. Therefore, I would urge
> >   for its mainline acceptance.
> >
> > (code for reference)
> > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> >
> > In this RFC (patch 1/3), I've decided to put the burden of
> > overclocking support to platform code (cpufreq/exynos-cpufreq.c and
> > cpufreq/exynos4x12-cpufreq.c).
> >
> > Those changes aren't intrusive for other boards/archs. Moreover
> > overclocking is closely related to processor clocking/power
> > dissipation capabilities, so SoC specific code is a good place for
> > it.
> >
> >
> > What DO need a broad acceptance is the overclocking API proposed at:
> > include/linux/cpufreq.h
> >
> > This introduces interface to which others will be bind. It
> > shouldn't be difficult to implement overclocking at other SoCs (as
> > it was proposed for Exynos).
> >
> > Feedback is welcome, since I might have overlooked oddities present
> > at other SoCs.
> 
> Hi..
> 
> I am not talking about the minute details here... for example I
> didn't like the way overclocking support is implemented... It has to
> be a bit more framework oriented then driver...
> 
> What I am thinking right now is if it is worth to add both the
> features you are trying. i.e. overclocking and LAB..
> 
> So, requested you to give some figures... of ondemand with and without
> overclocking... Leave LAB for now...
> 
> Then we can give LAB a try with above...

Test HW Exynos4412 (4 Cores):
Kernel 3.8.3

Ondemand max freq: 1.4 GHz
Overclock max freq: 1.5 GHz


Ondemand improvement with and without overclocking (called by us
TurboBoost - TB):

Dhrystone has been built according to:
http://zenit.senecac.on.ca/wiki/index.php/Dhrystone_howto
It's Makefile is also attached.
------------------------------------------------

Dhrystone	# of Threads			
		1	2	3	4
ondemand	2054794	2061855	2097902	2090592
ondemand + TB	2290076	2205882	2281368 2290076

Improvement:	10%	7%	8%	9%
-------------------------------------------------

Electric charge [C]
(Avg) [A] * [second]	# of Threads			
		1	2	3	4
ondemand	1,334	1,837	2,296	3,096
ondemand + TB	1,401	2,2025	2,907	4,34976
								
Power cost:	5%	17%	21%	29%
-------------------------------------------------

Execution time [second]	# of Threads			
		1	2	3	4
ondemand	2,827	2,8	2,787	2,872
ondemand + TB	2,622	2,694	2,667	2,76
				
				
Speedup:	-7%	-4%	-4%	-4%

-------------------------------------------------

"Real life" example:
time tar -czf linux-3.9.1.tar.gz linux-3.9.1/

		Avg current[mA]		Time[s]
Ondemand:	460			153	
Ondemand + TB:	512			144

Result:		+10%			-6%



Conclusion: 

The main use case for TB is to speed up execution of tasks packed to
one core. Other cores are then in IDLE state.

For a single core we can safely overclock, since we will not exceed its
power consumption and thermal limits.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group

--MP_/1.Do/nwES91iYxHNqTqzEVd
Content-Type: application/octet-stream; name=Makefile
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=Makefile

IwojCUFkanVzdCBmb3IgeW91ciBzeXN0ZW0hCiMKIwlDb21tb24gb3B0aW9ucyBmb3IgZ2VuZXJp
YyBVTklYIGFuZCBNaWNyb3NvZnQgQyAodW5kZXIgRE9TKQojCWFyZSBsaXN0ZWQgaGVyZS4gIFlv
dSBjYW4gY2hhbmdlIHRoZW0gYnkgc3dpdGNoaW5nIHRoZSBvcmRlciwKIwlwbGFjaW5nIHRoZSBv
bmVzIHlvdSB3YW50IGxhc3QuICBQYXkgcGFydGljdWxhciBhdHRlbnRpb24gdG8KIwl0aGUgSFog
cGFyYW1ldGVyLCB3aGljaCBtYXkgb3IgbWF5IG5vdCBiZSBsaXN0ZWQgaW4gc29tZQojCWhlYWRl
ciBmaWxlIG9uIHlvdXIgc3lzdGVtLCBzdWNoIGFzIDxzeXMvcGFyYW0uaD4gb3IgPGxpbWl0cy5o
PgojCShhcyBDTEtfVENLKS4gIEV2ZW4gaWYgaXQgaXMgbGlzdGVkLCBpdCBtYXkgYmUgaW5jb3Jy
ZWN0LgojCUFsc28sIHNvbWUgb3BlcmF0aW5nIHN5c3RlbXMgKG5vdGFibHkgc29tZSAoYWxsPykg
dmVyc2lvbnMKIwlvZiBNaWNyb3BvcnQgVU5JWCkgbGllIGFib3V0IHRoZSB0aW1lLiAgU2FuaXR5
IGNoZWNrIHdpdGggYQojCXN0b3B3YXRjaC4KIwojCUZvciBNaWNyb3NvZnQgQyB1bmRlciBET1Ms
IHlvdSBuZWVkIGEgcmVhbCBtYWtlLCBub3QgTVNDIG1ha2UsCiMJdG8gcnVuIHRoaXMgTWFrZWZp
bGUuICBUaGUgcHVibGljIGRvbWFpbiAibmRtYWtlIiB3aWxsIHN1ZmZpY2UuCiMKQ0M9CQljbAkJ
CSMgQyBjb21waWxlciBuYW1lIGdvZXMgaGVyZSAoTVNDKQpDQz0JCWNjCQkJIyBDIGNvbXBpbGVy
IG5hbWUgZ29lcyBoZXJlIChVTklYKQpHQ0M9CQlhcm0tZ2NjCgpQUk9HUz0JCXVuaXgJCQkjIFBy
b2dyYW1zIHRvIGJ1aWxkIChVTklYKQoKI1RJTUVfRlVOQz0JLURNU0NfQ0xPQ0sJCSMgVXNlIE1p
Y3Jvc29mdCBjbG9jaygpIGZvciBtZWFzdXJlbWVudAojVElNRV9GVU5DPQktRFRJTUUJCQkjIFVz
ZSB0aW1lKDIpIGZvciBtZWFzdXJlbWVudApUSU1FX0ZVTkM9CS1EVElNRVMJCQkjIFVzZSB0aW1l
cygyKSBmb3IgbWVhc3VyZW1lbnQKI0haPQkJNTAJCQkjIEZyZXF1ZW5jeSBvZiB0aW1lcygyKSBj
bG9jayB0aWNrcwpIWj0JCTYwCQkJIyBGcmVxdWVuY3kgb2YgdGltZXMoMikgY2xvY2sgdGlja3MK
I0haPQkJMTAwCQkJIyBGcmVxdWVuY3kgb2YgdGltZXMoMikgY2xvY2sgdGlja3MKI0haPQkJMQkJ
CSMgR2l2ZSBib2d1cyByZXN1bHQgdW5sZXNzIGNoYW5nZWQhCgpTVFJVQ1RBU1NJR049CS1ETk9T
VFJVQ1RBU1NJR04JIyBDb21waWxlciBjYW5ub3QgYXNzaWduIHN0cnVjdHMKU1RSVUNUQVNTSUdO
PQkJCQkjIENvbXBpbGVyIGNhbiBhc3NpZ24gc3RydWN0cwoKRU5VTVM9CQktRE5PRU5VTVMJCSMg
Q29tcGlsZXIgZG9lc24ndCBoYXZlIGVudW0gdHlwZQpFTlVNUz0JCQkJCSMgQ29tcGlsZXIgZG9l
cyBoYXZlIGVudW0gdHlwZQoKT1BUSU1JWkU9CS1PeCAtRzIJCQkjIE9wdGltaXphdGlvbiBMZXZl
bCAoTVNDLCA4MDI4NikKT1BUSU1JWkU9CS1PNAkJCSMgT3B0aW1pemF0aW9uIExldmVsIChnZW5l
cmljIFVOSVgpCkdDQ09QVElNPSAgICAgICAtTwoKTEZMQUdTPQkJCQkJI0xvYWRlciBGbGFncwoK
Q0ZMQUdTPQkkKE9QVElNSVpFKSAkKFRJTUVfRlVOQykgLURIWj0kKEhaKSAkKEVOVU1TKSAkKFNU
UlVDVEFTU0lHTikgJChDRkwpCkdDQ0ZMQUdTPSAkKEdDQ09QVElNKSAkKFRJTUVfRlVOQykgLURI
Wj0kKEhaKSAkKEVOVU1TKSAkKFNUUlVDVEFTU0lHTikgJChDRkwpCgojCiMJCVlvdSBzaG91bGRu
J3QgbmVlZCB0byB0b3VjaCB0aGUgcmVzdAojClNSQz0JCWRocnlfMS5jIGRocnlfMi5jCkhEUj0J
CWRocnkuaAoKVU5JWF9QUk9HUz0JZ2NjX2RyeTIgZ2NjX2RyeTJyZWcKCiMgRmlsZXMgYWRkZWQg
YnkgcmVyOgpGSUxFUzE9CQlSRUFETUUuUkVSIGNsYXJpZnkuZG9jIE1ha2VmaWxlIHN1Ym1pdC5m
cm0gcHVyZTJfMS5kaWYgXAoJCWRocnlfYy5kaWYKIyBSZWluaG9sZCdzIGZpbGVzOgpGSUxFUzI9
CQlSRUFETUUgUkFUSU9OQUxFICQoSERSKSAkKFNSQykKRklMRVMzPQkJZGhyeS5wCgphbGw6CSQo
UFJPR1MpCgp1bml4OgkkKFVOSVhfUFJPR1MpCgpnY2NfZHJ5MjoJCSQoU1JDKSAkKEhEUikKCQkk
KEdDQykgJChHQ0NGTEFHUykgJChTUkMpICQoTEZMQUdTKSAtbyAkQAoKZ2NjX2RyeTJyZWc6CSQo
U1JDKSAkKEhEUikKCQkkKEdDQykgJChHQ0NGTEFHUykgLURSRUc9cmVnaXN0ZXIgJChTUkMpICQo
TEZMQUdTKSAtbyAkQAo=

--MP_/1.Do/nwES91iYxHNqTqzEVd--
