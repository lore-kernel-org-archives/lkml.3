Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3FKSgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:36:18 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57505 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3FKSgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:36:16 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: next-20130607 BUG: sleeping function called from invalid context at lib/idr.c:424
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1370975638_1896P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Jun 2013 14:33:58 -0400
Message-ID: <19828.1370975638@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.51B76D98.0134,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2013-04-19 10:07:54,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1370975638_1896P
Content-Type: text/plain; charset=us-ascii

Tried to boot next-20130607, got this during early boot.  -0603 is OK, so
whatever did it is a recent patch. Not sure who's fault it is, as idr_preload()
has been there since February, apparently something in the SyS_semget()
path has been changed...

Looking at 'git blame', I see a bunch of patches from Davidlohr Bueso on 06/07
that hit ipc/util.c and friends.

[   17.332871] BUG: sleeping function called from invalid context at lib/idr.c:424
[   17.333013] in_atomic(): 0, irqs_disabled(): 0, pid: 231, name: systemd-cryptse
[   17.333135] 2 locks held by systemd-cryptse/231:
[   17.333226]  #0:  (&ids->rw_mutex){+++++.}, at: [<ffffffff811de265>] ipcget+0x58/0x162
[   17.333650]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e020e>] rcu_read_lock+0x0/0x6c
[   17.334103] CPU: 0 PID: 231 Comm: systemd-cryptse Not tainted 3.10.0-rc4-next-20130607 #79
[   17.334227] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A11 03/12/2013
[   17.334347]  0000000000000000 ffff8801254e3e18 ffffffff815ebdd7 ffff88012545ecc0
[   17.334706]  ffff8801254e3e40 ffffffff8105b59b ffff8801262a1600 ffffffff81a3ee28
[   17.335088]  00000000000000d0 ffff8801254e3e70 ffffffff812377ec ffff8801262a1618
[   17.335445] Call Trace:
[   17.335535]  [<ffffffff815ebdd7>] dump_stack+0x4f/0x9a
[   17.335633]  [<ffffffff8105b59b>] __might_sleep+0x19e/0x1a5
[   17.335730]  [<ffffffff812377ec>] idr_preload+0xb7/0x15c
[   17.335827]  [<ffffffff811ddd0c>] ipc_addid+0x3a/0x168
[   17.335924]  [<ffffffff811e055f>] newary+0xa5/0x1b7
[   17.336040]  [<ffffffff811de349>] ipcget+0x13c/0x162
[   17.336139]  [<ffffffff811e19a8>] SyS_semget+0x5d/0x69
[   17.336233]  [<ffffffff811e04ba>] ? semctl_nolock.constprop.15+0x240/0x240
[   17.336332]  [<ffffffff811dfb4c>] ? sysvipc_sem_proc_show+0x9b/0x9b
[   17.336430]  [<ffffffff811df9f5>] ? __ticket_spin_is_locked+0x11/0x11
[   17.336529]  [<ffffffff815f9dd2>] system_call_fastpath+0x16/0x1b
[   17.344508] bio: create slab <bio-1> at 1



--==_Exmh_1370975638_1896P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUbdtlgdmEQWDXROgAQKm9Q//RMfMbS3tPJ5c/6hTHkmeOqxXLNOJlbmu
IdctLqXxBJKSkAYQgKOnM4PgBn3jRpLHyxFxExHEPQjYXCy2CimdNQnWBKHQGdwx
yH0DQdvK5JOyURFNzEezdeCbq/o6Y3FFC2WfM4o9FmTgRPfzR4HwU1dk/Hgt9+S+
1bkn6EiIqOCZJVB7cgLspfu1qyiv9F/WT+IEBNwY+G316fTgSPnEt9TJjXrcUp7P
wvRWOtNbiexETFdUoRwkXubfYmE5DS5K9KVMf4N5f0oNfol9w5A4JPnZWmoTXUD+
C2slIkKRUwSlNrZAsTaESEofAszOOrw1biz09yelpVKB3iETcJE5Ng7GrczGGSFi
5uUEnN0Nmmodm+76VdWMBj3OSw2IcdtXfQW999K0JnWcDk6IEOH0YdqP2P/knVWo
sqohgoZQkvVQjHYpD/1mwpD+eg6eCiNUMBUzhEAWMjWhH/dCJMtSlAxwFmm9HVOy
CF83rcf+eHRb6/w58GUPVzrxhL7mS2jRd4+fkUz8nTqJDoPPh9a4/U1v1CCDpgNQ
rNqllH6z9Kd9rddSx9heOaW7gbzs71ubHsTvPFx6LqAsziJDpB5Y92/bzRkodVvs
4mxPsvu6VeXHNwfnwc5X/m9hGwhCk90pf5FjKXuaJ6dZEvovY4RtZCqAzsmux8x/
V5RDEPMCUwA=
=6qz0
-----END PGP SIGNATURE-----

--==_Exmh_1370975638_1896P--

