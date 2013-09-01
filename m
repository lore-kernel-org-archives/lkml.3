Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3IAKdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:33:13 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39184 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3IAKdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:33:11 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
Date: Sun, 1 Sep 2013 12:33:07 +0200
Message-ID: <CA+icZUU7D_tSqQV2-BKF8LKhx1NGVD+Yeguw=5N0qN=Bt3ZyZg@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: multipart/mixed; boundary=e89a8f646ff94c76bb04e54ffb44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f646ff94c76bb04e54ffb44
Content-Type: text/plain; charset=UTF-8

On Sun, Sep 1, 2013 at 12:01 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Aug 30, 2013 at 6:52 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Fri, Aug 30, 2013 at 9:37 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>
>>> Where is this a.out file from or how to generate it?
>>
>> Oh, that's just the silly threaded test-binary. I don't know what you
>> called it.
>>
>> As to your config options, yesh, you have some expensive stuff.
>> DEBUG_OBJECTS and DEBUG_MUTEXES in particular tend to cause lots of
>> horrible performance issues. I didn't check if there might be other
>> things..
>>
>
> I tried w/o DEBUG_OBJECTS and DEBUG_MUTEXES and disabled some
> unnecessary debug-options, too (see attached diff).
>
> This is what I get now...
>
> [ TEST-CASE ]
>
> $ ~/src/linux-kernel/linux/tools/perf/perf stat --null --repeat 5
> ./scripts/t_lockref_from-linus
> Total loops: 26480075
> Total loops: 27002388
> Total loops: 25761463
> Total loops: 26877615
> Total loops: 27047644
>
>  Performance counter stats for './scripts/t_lockref_from-linus' (5 runs):
>
>       10,008617789 seconds time elapsed
>           ( +-  0,07% )
>
>
> Looks like this is now 10x faster: ~2.66Mloops (debug) VS.
> ~26.60Mloops (no-debug).
>
> [ PERF-RECORD ]
>
> $ sudo ~/src/linux-kernel/linux/tools/perf/perf record -e cycles:pp
> ./scripts/t_lockref_from-linus
> Total loops: 26601346
> [ perf record: Woken up 25 times to write data ]
> [ perf record: Captured and wrote 6.100 MB perf.data (~266501 samples) ]
>
> [ PERF-REPORT ]
>
> $ sudo ~/src/linux-kernel/linux/tools/perf/perf report -f
>
> Samples: 159K of event 'cycles:pp', Event count (approx.): 76968896763
>  12,79%  t_lockref_from-  [kernel.kallsyms]     [k] irq_return
>   4,36%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_lock
>   4,36%  t_lockref_from-  [kernel.kallsyms]     [k] __acct_update_integrals
>   4,07%  t_lockref_from-  [kernel.kallsyms]     [k] user_exit
>   3,12%  t_lockref_from-  [kernel.kallsyms]     [k] local_clock
>   2,83%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_get_or_lock
>   2,73%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_alloc
>   2,62%  t_lockref_from-  [kernel.kallsyms]     [k] __d_lookup_rcu
>   2,53%  t_lockref_from-  libc-2.15.so          [.] __xstat64
>   2,53%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_free
>   2,28%  t_lockref_from-  [kernel.kallsyms]     [k] path_init
>   2,27%  t_lockref_from-  [kernel.kallsyms]     [k] link_path_walk
>   1,86%  t_lockref_from-  [kernel.kallsyms]     [k] user_enter
>   1,85%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_exit_common.isra.43
>   1,81%  t_lockref_from-  [kernel.kallsyms]     [k] sched_clock_cpu
>   1,79%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_enter_common.isra.45
>   1,78%  t_lockref_from-  [kernel.kallsyms]     [k] path_lookupat
>   1,67%  t_lockref_from-  [kernel.kallsyms]     [k] native_read_tsc
>   1,63%  t_lockref_from-  [kernel.kallsyms]     [k] cp_new_stat
>   1,61%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_put_or_lock
>   1,53%  t_lockref_from-  [kernel.kallsyms]     [k] account_system_time
>   1,48%  t_lockref_from-  [kernel.kallsyms]     [k] tracesys
>   1,47%  t_lockref_from-  [kernel.kallsyms]     [k] copy_user_generic_unrolled
>   1,46%  t_lockref_from-  [kernel.kallsyms]     [k] syscall_trace_enter
>   1,39%  t_lockref_from-  [kernel.kallsyms]     [k] jiffies_to_timeval
>   1,33%  t_lockref_from-  [kernel.kallsyms]     [k] native_sched_clock
>   1,27%  t_lockref_from-  [kernel.kallsyms]     [k] getname_flags
>   1,27%  t_lockref_from-  [kernel.kallsyms]     [k] lookup_fast
>   1,18%  t_lockref_from-  [kernel.kallsyms]     [k] get_vtime_delta
>   1,05%  t_lockref_from-  [kernel.kallsyms]     [k] syscall_trace_leave
>   1,03%  t_lockref_from-  [kernel.kallsyms]     [k] generic_fillattr
>   1,02%  t_lockref_from-  [kernel.kallsyms]     [k] strncpy_from_user
>   1,00%  t_lockref_from-  [kernel.kallsyms]     [k] user_path_at_empty
>   0,97%  t_lockref_from-  [kernel.kallsyms]     [k] account_user_time
>   0,95%  t_lockref_from-  [kernel.kallsyms]     [k] vfs_fstatat
>   0,95%  t_lockref_from-  [kernel.kallsyms]     [k] system_call_after_swapgs
>   0,92%  t_lockref_from-  [kernel.kallsyms]     [k] generic_permission
>   0,91%  t_lockref_from-  [kernel.kallsyms]     [k] filename_lookup
>   0,80%  t_lockref_from-  [kernel.kallsyms]     [k] vfs_getattr
>   0,78%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_unlock
>   0,74%  t_lockref_from-  [kernel.kallsyms]     [k] complete_walk
>   0,70%  t_lockref_from-  [kernel.kallsyms]     [k] vtime_account_user
>   0,68%  t_lockref_from-  [kernel.kallsyms]     [k] d_rcu_to_refcount
>   0,65%  t_lockref_from-  [kernel.kallsyms]     [k] common_perm
>   0,62%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_enter
>   0,58%  t_lockref_from-  [kernel.kallsyms]     [k] vtime_user_enter
>   0,57%  t_lockref_from-  [kernel.kallsyms]     [k] __inode_permission
>   0,55%  t_lockref_from-  [kernel.kallsyms]     [k] dput
>   0,52%  t_lockref_from-  [kernel.kallsyms]     [k] apparmor_inode_getattr
>   0,52%  t_lockref_from-  [kernel.kallsyms]     [k] SYSC_newstat
>   0,52%  t_lockref_from-  [kernel.kallsyms]     [k] mntget
>   0,49%  t_lockref_from-  [kernel.kallsyms]     [k] cpuacct_account_field
>   0,48%  t_lockref_from-  [kernel.kallsyms]     [k] __vtime_account_system
>   0,46%  t_lockref_from-  t_lockref_from-linus  [.] start_routine
>
> Thanks for all the explanations and hints.
>
> Regards,
> - Sedat -
>
> P.S.: Some words to "perf -f"...
>
> $ sudo ~/src/linux-kernel/linux/tools/perf/perf record -f -e cycles:pp
> ./scripts/t_lockref_from-linus
> [sudo] password for wearefam:
>   Error: unknown switch `f'
>
>  usage: perf record [<options>] [<command>]
>     or: perf record [<options>] -- <command> [<options>]
>
>     -e, --event <event>   event selector. use 'perf list' to list
> available events
>         --filter <filter>
>                           event filter
>     -p, --pid <pid>       record events on existing process id
>     -t, --tid <tid>       record events on existing thread id
>     -r, --realtime <n>    collect data with this RT SCHED_FIFO priority
>     -D, --no-delay        collect data without buffering
>     -R, --raw-samples     collect raw sample records from all opened counters
>     -a, --all-cpus        system-wide collection from all CPUs
>     -C, --cpu <cpu>       list of cpus to monitor
>     -c, --count <n>       event period to sample
>     -o, --output <file>   output file name
>     -i, --no-inherit      child tasks do not inherit counters
>     -F, --freq <n>        profile at this frequency
>     -m, --mmap-pages <n>  number of mmap data pages
>         --group           put the counters into a counter group
>     -g, --call-graph <mode[,dump_size]>
>                           do call-graph (stack chain/backtrace)
> recording: [fp] dwarf
>     -v, --verbose         be more verbose (show counter open errors, etc)
>     -q, --quiet           don't print any message
>     -s, --stat            per thread counts
>     -d, --data            Sample addresses
>     -T, --timestamp       Sample timestamps
>     -P, --period          Sample period
>     -n, --no-samples      don't sample
>     -N, --no-buildid-cache
>                           do not update the buildid cache
>     -B, --no-buildid      do not collect buildids in perf.data
>     -G, --cgroup <name>   monitor event in cgroup name only
>     -u, --uid <user>      user to profile
>     -b, --branch-any      sample any taken branches
>     -j, --branch-filter <branch filter mask>
>                           branch stack filter modes
>     -W, --weight          sample by weight (on special events only)
>
> - EOT -

Attached are the results without the patch from Linus.

- Sedat -

--e89a8f646ff94c76bb04e54ffb44
Content-Type: text/plain; charset=US-ASCII; 
	name="RESULTS_SPINLOCK-LOCKREF-TESTING_WITHOUT-PATCH_3.11.0-rc7-3-iniza-small.txt"
Content-Disposition: attachment; 
	filename="RESULTS_SPINLOCK-LOCKREF-TESTING_WITHOUT-PATCH_3.11.0-rc7-3-iniza-small.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl24ebdx1

JCBkaWZmIC11cHJOIC9ib290L2NvbmZpZy0zLjExLjAtcmM3LTMtaW5pemEtc21hbGwgL2Jvb3Qv
Y29uZmlnLTMuMTEuMC1yYzctMy1sb2NrcmVmLXNtYWxsIAotLS0gL2Jvb3QvY29uZmlnLTMuMTEu
MC1yYzctMy1pbml6YS1zbWFsbCAgICAgICAyMDEzLTA5LTAxIDEyOjE3OjUxLjAwMDAwMDAwMCAr
MDIwMAorKysgL2Jvb3QvY29uZmlnLTMuMTEuMC1yYzctMy1sb2NrcmVmLXNtYWxsICAgICAyMDEz
LTA5LTAxIDExOjIzOjIxLjAwMDAwMDAwMCArMDIwMApAQCAtNDMzNCw2ICs0MzM0LDggQEAgQ09O
RklHX0dFTkVSSUNfUENJX0lPTUFQPXkKIENPTkZJR19HRU5FUklDX0lPTUFQPXkKIENPTkZJR19H
RU5FUklDX0lPPXkKIENPTkZJR19QRVJDUFVfUldTRU09eQorQ09ORklHX0FSQ0hfVVNFX0NNUFhD
SEdfTE9DS1JFRj15CitDT05GSUdfQ01QWENIR19MT0NLUkVGPXkKICMgQ09ORklHX0NSQ19DQ0lU
VCBpcyBub3Qgc2V0CiBDT05GSUdfQ1JDMTY9eQogQ09ORklHX0NSQ19UMTBESUY9eQoKCiQgY2F0
IC9wcm9jL3ZlcnNpb24gCkxpbnV4IHZlcnNpb24gMy4xMS4wLXJjNy0zLWluaXphLXNtYWxsIChz
ZWRhdC5kaWxla0BnbWFpbC5jb21AZmFtYm94KSAoZ2NjIHZlcnNpb24gNC42LjMgKFVidW50dS9M
aW5hcm8gNC42LjMtMXVidW50dTUpICkgIzEgU01QIFN1biBTZXAgMSAxMjoxNzozMyBDRVNUIDIw
MTMKCgokIH4vc3JjL2xpbnV4LWtlcm5lbC9saW51eC90b29scy9wZXJmL3BlcmYgc3RhdCAtLW51
bGwgLS1yZXBlYXQgNSAuL3NjcmlwdHMvdF9sb2NrcmVmX2Zyb20tbGludXMKVG90YWwgbG9vcHM6
IDI1NTI4MzQ4ClRvdGFsIGxvb3BzOiAyNTkyNDA4MApUb3RhbCBsb29wczogMjU1MTM0MDUKVG90
YWwgbG9vcHM6IDI1NjE5ODEyClRvdGFsIGxvb3BzOiAyNTYzNDEwNwoKIFBlcmZvcm1hbmNlIGNv
dW50ZXIgc3RhdHMgZm9yICcuL3NjcmlwdHMvdF9sb2NrcmVmX2Zyb20tbGludXMnICg1IHJ1bnMp
OgoKICAgICAgMTAsMDAyMjkzNDUyIHNlY29uZHMgdGltZSBlbGFwc2VkICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKCArLSAgMCwwMCUgKQoKCiQgc3VkbyB+L3NyYy9s
aW51eC1rZXJuZWwvbGludXgvdG9vbHMvcGVyZi9wZXJmIHJlY29yZCAtZSBjeWNsZXM6cHAgLi9z
Y3JpcHRzL3RfbG9ja3JlZl9mcm9tLWxpbnVzClRvdGFsIGxvb3BzOiAyNTI1MTUwNwpbIHBlcmYg
cmVjb3JkOiBXb2tlbiB1cCAyNSB0aW1lcyB0byB3cml0ZSBkYXRhIF0KWyBwZXJmIHJlY29yZDog
Q2FwdHVyZWQgYW5kIHdyb3RlIDYuMTA4IE1CIHBlcmYuZGF0YSAofjI2Njg1NyBzYW1wbGVzKSBd
CgoKU2FtcGxlczogMTU5SyBvZiBldmVudCAnY3ljbGVzOnBwJywgRXZlbnQgY291bnQgKGFwcHJv
eC4pOiA3NjkxNDgyNDI1NiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAxMiwxNiUg
IHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBpcnFfcmV0dXJuCiAx
MCw3NCUgIHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBfX3RpY2tl
dF9zcGluX2xvY2sKICA0LDEwJSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAg
ICAgW2tdIF9fYWNjdF91cGRhdGVfaW50ZWdyYWxzCiAgMyw3OSUgIHRfbG9ja3JlZl9mcm9tLSAg
W2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSB1c2VyX2V4aXQKICAyLDk4JSAgdF9sb2NrcmVmX2Zy
b20tICBba2VybmVsLmthbGxzeW1zXSAgICAgW2tdIGxvY2FsX2Nsb2NrCiAgMiw1NiUgIHRfbG9j
a3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBfX2RfbG9va3VwX3JjdQogIDIs
NTAlICB0X2xvY2tyZWZfZnJvbS0gIGxpYmMtMi4xNS5zbyAgICAgICAgICBbLl0gX194c3RhdDY0
CiAgMiw0NyUgIHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBrbWVt
X2NhY2hlX2FsbG9jCiAgMiwzNiUgIHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10g
ICAgIFtrXSBrbWVtX2NhY2hlX2ZyZWUKICAyLDM2JSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVs
LmthbGxzeW1zXSAgICAgW2tdIGxpbmtfcGF0aF93YWxrCiAgMSw4MiUgIHRfbG9ja3JlZl9mcm9t
LSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSB0cmFjZXN5cwogIDEsNzglICB0X2xvY2tyZWZf
ZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAgICBba10gcmN1X2Vxc19lbnRlcl9jb21tb24uaXNy
YS40NQogIDEsNzYlICB0X2xvY2tyZWZfZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAgICBba10g
cmN1X2Vxc19leGl0X2NvbW1vbi5pc3JhLjQzCiAgMSw3NSUgIHRfbG9ja3JlZl9mcm9tLSAgW2tl
cm5lbC5rYWxsc3ltc10gICAgIFtrXSB1c2VyX2VudGVyCiAgMSw2OCUgIHRfbG9ja3JlZl9mcm9t
LSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBwYXRoX2xvb2t1cGF0CiAgMSw2OCUgIHRfbG9j
a3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBzY2hlZF9jbG9ja19jcHUKICAx
LDUzJSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAgICAgW2tdIG5hdGl2ZV9y
ZWFkX3RzYwogIDEsNTAlICB0X2xvY2tyZWZfZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAgICBb
a10gY3BfbmV3X3N0YXQKICAxLDQ5JSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1z
XSAgICAgW2tdIGRwdXQKICAxLDQzJSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1z
XSAgICAgW2tdIGNvcHlfdXNlcl9nZW5lcmljX3Vucm9sbGVkCiAgMSwzOSUgIHRfbG9ja3JlZl9m
cm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBwYXRoX2luaXQKICAxLDM5JSAgdF9sb2Nr
cmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAgICAgW2tdIGFjY291bnRfc3lzdGVtX3RpbWUK
ICAxLDM4JSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAgICAgW2tdIHN5c2Nh
bGxfdHJhY2VfZW50ZXIKICAxLDM1JSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1z
XSAgICAgW2tdIF9fdGlja2V0X3NwaW5fdW5sb2NrCiAgMSwzMSUgIHRfbG9ja3JlZl9mcm9tLSAg
W2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBqaWZmaWVzX3RvX3RpbWV2YWwKICAxLDI3JSAgdF9s
b2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAgICAgW2tdIG5hdGl2ZV9zY2hlZF9jbG9j
awogIDEsMjQlICB0X2xvY2tyZWZfZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAgICBba10gbG9v
a3VwX2Zhc3QKICAxLDI0JSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAgICAg
W2tdIGNvbXBsZXRlX3dhbGsKICAxLDIzJSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxz
eW1zXSAgICAgW2tdIHZmc19nZXRhdHRyCiAgMSwxNyUgIHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5l
bC5rYWxsc3ltc10gICAgIFtrXSBnZXRuYW1lX2ZsYWdzCiAgMSwwNiUgIHRfbG9ja3JlZl9mcm9t
LSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBnZXRfdnRpbWVfZGVsdGEKICAxLDA2JSAgdF9s
b2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAgICAgW2tdIHN5c2NhbGxfdHJhY2VfbGVh
dmUKICAwLDk0JSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAgICAgW2tdIGdl
bmVyaWNfZmlsbGF0dHIKICAwLDkzJSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxzeW1z
XSAgICAgW2tdIGFjY291bnRfdXNlcl90aW1lCiAgMCw5MiUgIHRfbG9ja3JlZl9mcm9tLSAgW2tl
cm5lbC5rYWxsc3ltc10gICAgIFtrXSBzdHJuY3B5X2Zyb21fdXNlcgogIDAsOTElICB0X2xvY2ty
ZWZfZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAgICBba10gdXNlcl9wYXRoX2F0X2VtcHR5CiAg
MCw5MCUgIHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBzeXN0ZW1f
Y2FsbF9hZnRlcl9zd2FwZ3MKICAwLDg4JSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmthbGxz
eW1zXSAgICAgW2tdIGZpbGVuYW1lX2xvb2t1cAogIDAsNzclICB0X2xvY2tyZWZfZnJvbS0gIFtr
ZXJuZWwua2FsbHN5bXNdICAgICBba10gYXBwYXJtb3JfaW5vZGVfZ2V0YXR0cgogIDAsNzQlICB0
X2xvY2tyZWZfZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAgICBba10gZ2VuZXJpY19wZXJtaXNz
aW9uCiAgMCw3MyUgIHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSB2
ZnNfZnN0YXRhdAogIDAsNjklICB0X2xvY2tyZWZfZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAg
ICBba10gX3Jhd19zcGluX2xvY2sKICAwLDY3JSAgdF9sb2NrcmVmX2Zyb20tICBba2VybmVsLmth
bGxzeW1zXSAgICAgW2tdIF9faW5vZGVfcGVybWlzc2lvbgogIDAsNjUlICB0X2xvY2tyZWZfZnJv
bS0gIFtrZXJuZWwua2FsbHN5bXNdICAgICBba10gdnRpbWVfYWNjb3VudF91c2VyCiAgMCw2NCUg
IHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBfX3RpY2tldF9zcGlu
X2lzX2xvY2tlZAogIDAsNTclICB0X2xvY2tyZWZfZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAg
ICBba10gdnRpbWVfdXNlcl9lbnRlcgogIDAsNTYlICB0X2xvY2tyZWZfZnJvbS0gIFtrZXJuZWwu
a2FsbHN5bXNdICAgICBba10gY29tbW9uX3Blcm0KICAwLDU2JSAgdF9sb2NrcmVmX2Zyb20tICBb
a2VybmVsLmthbGxzeW1zXSAgICAgW2tdIHJjdV9lcXNfZW50ZXIKICAwLDU2JSAgdF9sb2NrcmVm
X2Zyb20tICBba2VybmVsLmthbGxzeW1zXSAgICAgW2tdIG1udGdldAogIDAsNTElICB0X2xvY2ty
ZWZfZnJvbS0gIFtrZXJuZWwua2FsbHN5bXNdICAgICBba10gY3B1YWNjdF9hY2NvdW50X2ZpZWxk
CiAgMCw0NyUgIHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBfX3Z0
aW1lX2FjY291bnRfc3lzdGVtCiAgMCw0NCUgIHRfbG9ja3JlZl9mcm9tLSAgW2tlcm5lbC5rYWxs
c3ltc10gICAgIFtrXSBsZ19sb2NhbF9sb2NrCiAgMCw0MyUgIHRfbG9ja3JlZl9mcm9tLSAgdF9s
b2NrcmVmX2Zyb20tbGludXMgIFsuXSBzdGFydF9yb3V0aW5lCiAgMCw0MyUgIHRfbG9ja3JlZl9m
cm9tLSAgW2tlcm5lbC5rYWxsc3ltc10gICAgIFtrXSBhY2N0X2FjY291bnRfY3B1dGltZQpQcmVz
cyAnPycgZm9yIGhlbHAgb24ga2V5IGJpbmRpbmdzCgoKLWRpbGVrcyAvLyAwMS1TZXAtMjAxMwoK
Cg==
--e89a8f646ff94c76bb04e54ffb44--
