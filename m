Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaEOSRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:17:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18285 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaEOSRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:17:17 -0400
Message-ID: <53750472.1040703@oracle.com>
Date: Thu, 15 May 2014 14:16:18 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        edumazet@google.com, viro@zeniv.linux.org.uk, jbaron@akamai.com
Subject: Re: eventpoll __list_del_entry corruption
References: <5370EBE9.6@oracle.com> <20140515181102.GH11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140515181102.GH11096@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oQgLL1wgngMQAI49DtsHuQvI8fF42NfhP"
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oQgLL1wgngMQAI49DtsHuQvI8fF42NfhP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/15/2014 02:11 PM, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest=
 -next
>> kernel I've stumbled on the following spew. Maybe related to the very =
recent
>> change in freeing on task exit?
>>
>=20
> While fuzzing to reproduce; I hit this one, is it a known one or should=

> I go poke the right people about it?
>=20
> ---
> [ 5823.689985] ------------[ cut here ]------------
> [ 5823.690004] WARNING: CPU: 3 PID: 2508 at /usr/src/linux-2.6/lib/list=
_debug.c:59 __list_del_entry+0xa1/0xd0()
> [ 5823.690004] list_del corruption. prev->next should be ffff880131111d=
e0, but was 6b6b6b6b6b6b6b6b
> [ 5823.690004] Modules linked in:
> [ 5823.690004] CPU: 3 PID: 2508 Comm: trinity-main Not tainted 3.15.0-r=
c5-01700-g505011124ad0-dirty #1072
> [ 5823.690004] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/=
2010
> [ 5823.690004]  0000000000000009 ffff880432709ca8 ffffffff81681aa2 ffff=
880432709cf0
> [ 5823.690004]  ffff880432709ce0 ffffffff8109807c ffff880131111de0 ffff=
880131111dc8
> [ 5823.690004]  0000000000000286 ffff8800b9dd5618 ffff88023699b720 ffff=
880432709d40
> [ 5823.690004] Call Trace:
> [ 5823.690004]  [<ffffffff81681aa2>] dump_stack+0x4e/0x7a
> [ 5823.690004]  [<ffffffff8109807c>] warn_slowpath_common+0x8c/0xc0
> [ 5823.690004]  [<ffffffff8109816c>] warn_slowpath_fmt+0x4c/0x50
> [ 5823.690004]  [<ffffffff810ec8bf>] ? do_raw_spin_lock+0x13f/0x160
> [ 5823.690004]  [<ffffffff8138c661>] __list_del_entry+0xa1/0xd0
> [ 5823.690004]  [<ffffffff8138c69d>] list_del+0xd/0x30
> [ 5823.690004]  [<ffffffff810dfa71>] remove_wait_queue+0x31/0x50
> [ 5823.690004]  [<ffffffff812152aa>] ep_unregister_pollwait.isra.9+0x6a=
/0xb0
> [ 5823.690004]  [<ffffffff81215268>] ? ep_unregister_pollwait.isra.9+0x=
28/0xb0
> [ 5823.690004]  [<ffffffff8121531f>] ep_remove+0x2f/0xe0
> [ 5823.690004]  [<ffffffff81215705>] eventpoll_release_file+0x65/0xa0
> [ 5823.690004]  [<ffffffff811cf259>] __fput+0x1d9/0x1e0
> [ 5823.690004]  [<ffffffff811cf2ae>] ____fput+0xe/0x10
> [ 5823.690004]  [<ffffffff810b91f4>] task_work_run+0xc4/0xe0
> [ 5823.690004]  [<ffffffff8109a544>] do_exit+0x2d4/0xa90
> [ 5823.690004]  [<ffffffff813825c4>] ? lockdep_sys_exit_thunk+0x35/0x67=

> [ 5823.690004]  [<ffffffff8109ae2c>] do_group_exit+0x4c/0xc0
> [ 5823.690004]  [<ffffffff8109aeb7>] SyS_exit_group+0x17/0x20
> [ 5823.690004]  [<ffffffff8168a2c2>] system_call_fastpath+0x16/0x1b
> [ 5823.690004] ---[ end trace 515b7fa3169c0906 ]---
>=20

Dave reported something similar to that last year(!) and that never got f=
ixed
AFAIK: https://lkml.org/lkml/2013/10/14/353.


Thanks,
Sasha


--oQgLL1wgngMQAI49DtsHuQvI8fF42NfhP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTdQR3AAoJEN6mb/eXdyzcJRIP/1VrOPR67+u4DAz4GSVKHR13
X911jqTn7+GmisGubuIMOgM5BcvWTDuSigi47Aesf13QMF38K1oKy1q0QKL2PBBX
Hv6ENqslaJ3fj0ljwNw/MCRhCPtqQxMF0nV4QLMm93ZqZr+oeLfXkRPvvwv6HciI
qybYJrsA6qbnttJLq6tuhuuSEHKkvxDyCsX9z12PpAlXqKmvFwscgli7kjBbvcop
t3VBcatZry3oyTp9dXzDkPrL6/EA7eaPU2Ehkv95ezGwvrpJxasxGsDKtGcI84C5
j+R5FiT+RghtPs87BmGHDZ3fwFGEuAsGXcGJNzgEIVbqBm40iwJAuDtW3Ao54B9d
Y/taEKJhwL63S72ALznbZVfPzGZQJimofz9OralyWfCM8JbBIqeGpmVQYct8j9RH
V7LTfXCduLoLRfkwmAfdb6P+IVG0RBRE+FCqKoEi0ojr7xRSxVBHSYKFg2vrCWtX
MHsmCsa2bB0QAuJDISXULcrkd6JVoE1C0TPVkQn7krm6R4ChM2TheWlct8uw6xJp
xrMoffvI/2bV6fQyzKftfVjM+evj+5r1mHiDhC50Of/E2BNDQ0GMDZKPnSkGHX3t
IIueqfgABZVSAFKrdhfZMXV3TbtU/Ae45h++KfmR5xCwO+QO72f+rz+nvEww7UkR
aqXVFJ4y7jWsoh+Azel+
=d85z
-----END PGP SIGNATURE-----

--oQgLL1wgngMQAI49DtsHuQvI8fF42NfhP--
