Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbbAWTw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:52:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53537 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbbAWTw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:52:26 -0500
Date: Fri, 23 Jan 2015 13:51:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: perf not capturing stack traces
Message-ID: <20150123195128.GE26557@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm using v3.19-rc5 on an ARM Cortex A9 board. Unfortunately, perf is
not able to capture any stack traces even though I CONFIG_STACKTRACE,
CONFIG_FRAME_POINTER and CONFIG_ARM_UNWIND all enabled.

I wonder if anybody else is facing similar issues.

Here's console grab:

perf record -e 'sched:*' -ag sleep 5  && perf report --stdio
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.092 MB perf.data (~4024 samples) ]
# To display the perf.data header info, please use --header/--header-only o=
ption
#
# Samples: 0  of event 'sched:sched_kthread_stop'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 0  of event 'sched:sched_kthread_stop_ret'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 62  of event 'sched:sched_wakeup'
# Event count (approx.): 62
#
# Children      Self  Command      Shared Object  Symbol       =20
# ........  ........  ...........  .............  ..............
:#
    74.19%    74.19%  swapper      [unknown]      [.] 00000000 =20
                |
                ---0

    11.29%    11.29%  kworker/0:2  [unknown]      [.] 00000000 =20
            |
            ---0

     9.68%     9.68%  perf         [unknown]      [.] 00000000 =20
                   |
                   ---0

     3.23%     3.23%  sleep        [unknown]      [.] 00000000 =20
                  |
                  ---0

     1.61%     1.61%  ksoftirqd/0  [unknown]      [.] 00000000 =20
            |
            ---0



:# Samples: 0  of event 'sched:sched_wakeup_new'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 102  of event 'sched:sched_switch'
# Event count (approx.): 102
#
# Children      Self  Command       Shared Object  Symbol       =20
# ........  ........  ............  .............  ..............
#
    31.37%    31.37%  swapper       [unknown]      [.] 00000000 =20
                 |
                 ---0

    20.59%    20.59%  kworker/0:2   [unknown]      [.] 00000000 =20
             |
             ---0

    15.69%    15.69%  ksoftirqd/0   [unknown]      [.] 00000000 =20
:             |
             ---0

    11.76%    11.76%  perf          [unknown]      [.] 00000000 =20
                    |
                    ---0

    11.76%    11.76%  sleep         [unknown]      [.] 00000000 =20
                   |
                   ---0

     7.84%     7.84%  rcu_sched     [unknown]      [.] 00000000 =20
               |
               ---0

     0.98%     0.98%  kworker/u2:1  [unknown]      [.] 00000000 =20
            |
            ---0



# Samples: 0  of event 'sched:sched_migrate_task'
# Event count (approx.): 0
:#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 0  of event 'sched:sched_process_free'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 1  of event 'sched:sched_process_exit'
# Event count (approx.): 1
#
# Children      Self  Command  Shared Object  Symbol       =20
# ........  ........  .......  .............  ..............
#
   100.00%   100.00%  sleep    [unknown]      [.] 00000000 =20
              |
              ---0
:


# Samples: 0  of event 'sched:sched_wait_task'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 0  of event 'sched:sched_process_wait'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 0  of event 'sched:sched_process_fork'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
:# ........  ........  .......  .............  ......
#


# Samples: 1  of event 'sched:sched_process_exec'
# Event count (approx.): 1
#
# Children      Self  Command  Shared Object  Symbol       =20
# ........  ........  .......  .............  ..............
#
   100.00%   100.00%  sleep    [unknown]      [.] 00000000 =20
              |
              ---0



# Samples: 70  of event 'sched:sched_stat_wait'
# Event count (approx.): 17926123
#
# Children      Self  Command      Shared Object  Symbol       =20
# ........  ........  ...........  .............  ..............
#
    33.13%    33.13%  ksoftirqd/0  [unknown]      [.] 00000000 =20
:            |
            ---0

    24.83%    24.83%  perf         [unknown]      [.] 00000000 =20
                   |
                   ---0

    21.44%    21.44%  sleep        [unknown]      [.] 00000000 =20
                  |
                  ---0

    20.60%    20.60%  rcu_sched    [unknown]      [.] 00000000 =20
              |
              ---0

     0.00%     0.00%  kworker/0:2  [unknown]      [.] 00000000 =20
            |
            ---0

     0.00%     0.00%  swapper      [unknown]      [.] 00000000 =20
                |
                ---0

:

# Samples: 43  of event 'sched:sched_stat_sleep'
# Event count (approx.): 119659990589
#
# Children      Self  Command  Shared Object  Symbol       =20
# ........  ........  .......  .............  ..............
#
    95.01%    95.01%  swapper  [unknown]      [.] 00000000 =20
            |
            ---0

     4.93%     4.93%  sleep    [unknown]      [.] 00000000 =20
              |
              ---0

     0.06%     0.06%  perf     [unknown]      [.] 00000000 =20
               |
               ---0



# Samples: 7  of event 'sched:sched_stat_iowait'
:# Event count (approx.): 37447751
#
# Children      Self  Command      Shared Object  Symbol       =20
# ........  ........  ...........  .............  ..............
#
   100.00%   100.00%  kworker/0:2  [unknown]      [.] 00000000 =20
            |
            ---0



# Samples: 19  of event 'sched:sched_stat_blocked'
# Event count (approx.): 42514750
#
# Children      Self  Command      Shared Object  Symbol       =20
# ........  ........  ...........  .............  ..............
#
    88.08%    88.08%  kworker/0:2  [unknown]      [.] 00000000 =20
            |
            ---0

     7.24%     7.24%  swapper      [unknown]      [.] 00000000 =20
                |
:                ---0

     3.81%     3.81%  ksoftirqd/0  [unknown]      [.] 00000000 =20
            |
            ---0

     0.86%     0.86%  perf         [unknown]      [.] 00000000 =20
                   |
                   ---0



# Samples: 79  of event 'sched:sched_stat_runtime'
# Event count (approx.): 46820375
#
# Children      Self  Command       Shared Object  Symbol       =20
# ........  ........  ............  .............  ..............
#
    27.85%    27.85%  perf          [unknown]      [.] 00000000 =20
                    |
                    ---0

    27.48%    27.48%  kworker/0:2   [unknown]      [.] 00000000 =20
:             |
             ---0

    20.79%    20.79%  sleep         [unknown]      [.] 00000000 =20
                   |
                   ---0

    12.51%    12.51%  ksoftirqd/0   [unknown]      [.] 00000000 =20
             |
             ---0

     8.96%     8.96%  rcu_sched     [unknown]      [.] 00000000 =20
               |
               ---0

     2.41%     2.41%  kworker/u2:1  [unknown]      [.] 00000000 =20
            |
            ---0



# Samples: 0  of event 'sched:sched_pi_setprio'
# Event count (approx.): 0
:#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 0  of event 'sched:sched_move_numa'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 0  of event 'sched:sched_stick_numa'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 0  of event 'sched:sched_swap_numa'
:# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#


# Samples: 0  of event 'sched:sched_wake_idle_without_ipi'
# Event count (approx.): 0
#
# Children      Self  Command  Shared Object  Symbol
# ........  ........  .......  .............  ......
#

--=20
balbi

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwqZAAAoJEIaOsuA1yqREMSAP/0fpnuMqaZKY3kkwr853KtJS
BMRN4bXqxH1wnZvu0UWRAT1JytlW79H9os/8WjqbXSUnVbBHtcz5I6SpN0DfOTAY
QfO/pJfs/sKskXcePjrIWLemtdv2UD1eWiuajO8PtDj/KKMu7rp8FIGblgX66UPm
d2lEKEZYC4n10r35R4QZIM8hXfQ+PqH34Ue+d8ux5kl1fjo0B2a5g8/oXkDBXSqp
+ABiovPTsnWzEmOoXmq6+E9uuNIPObayaHPWhgo80fjtSeA61T9bE+/67bsgrbsX
4Z/HJZ9gSOff5buve4krFZhOE+9i2TrnGpqw/5846tsUYsodqpIFMyYvtpF8ov9B
OvrxBy/weulKNjwgmkbr2OpTU6nRCLcrsb8goDohH3Vyp1kVB0Y431+dWX17/a+W
oXarKUWfIq/2VNvmo3IJAmgGim6+7IDVpABVwt9rgchcoytMlUUKhS/XT86h9Zsx
xLEMTgj897wnQ4Y2KvHDSvIclyvOPWDNxGq3ROlR5yI9gvt+71ORkjYv5xcJvPsu
2HWqeydztQF/XLGVSFsmL6be3ZrLqLZhKK09LcAxe/dYVt5q3jUSNFwiABjrDt12
hDod6qOzVNpekA6TBZ2v2QQG0eryAyEVC8sEaqHqUErW8YzB0oJdrSNygAVT+93k
EPsXWrP5M5dY8MS0YyzG
=bTn+
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
