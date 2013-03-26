Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3CZSGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:06:24 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38991 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3CZSGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:06:18 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: next-20130325 - INFO: trying to register non-static key.
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1364321163_1855P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Mar 2013 14:06:03 -0400
Message-ID: <11740.1364321163@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.5151E396.00EA,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1364321163_1855P
Content-Type: text/plain; charset=us-ascii

Seen in the dmesg for next-20130325, but looks like it's been doing
it since at least next-20130218.

[   50.162584] dell_wmi: Received unknown WMI event (0x11)
[   51.167629] INFO: trying to register non-static key.
[   51.167636] the code is fine but needs lockdep annotation.
[   51.167639] turning off the locking correctness validator.
[   51.167644] Pid: 594, comm: kworker/0:3 Tainted: G        W  O 3.9.0-rc4-next-20130325 #67
[   51.167646] Call Trace:
[   51.167656]  [<ffffffff81073847>] register_lock_class+0x108/0x2ba
[   51.167662]  [<ffffffff81075113>] __lock_acquire+0x126/0xde2
[   51.167667]  [<ffffffff810755de>] ? __lock_acquire+0x5f1/0xde2
[   51.167671]  [<ffffffff81076111>] lock_acquire+0xc7/0x14a
[   51.167677]  [<ffffffff810498dd>] ? process_one_work+0x1fd/0x4ae
[   51.167681]  [<ffffffff81049949>] process_one_work+0x269/0x4ae
[   51.167686]  [<ffffffff810498dd>] ? process_one_work+0x1fd/0x4ae
[   51.167691]  [<ffffffff8104ae2c>] worker_thread+0x2d6/0x3dc
[   51.167696]  [<ffffffff8104ab56>] ? rescuer_thread+0x343/0x343
[   51.167701]  [<ffffffff81050394>] kthread+0x9d/0xa5
[   51.167706]  [<ffffffff810502f7>] ? __kthread_parkme+0x60/0x60
[   51.167712]  [<ffffffff815fdf6c>] ret_from_fork+0x7c/0xb0
[   51.167717]  [<ffffffff810502f7>] ? __kthread_parkme+0x60/0x60

'git blame' doesn't seem to shout anything.  Commit 112202d90 touched code
in that area semi-recently, but I don't actually see a problem with it.

(I admit not being sure how long this has been an issue - discovered I
had a local config screw-up that meant lockdep wasn't on for quite some
time).

--==_Exmh_1364321163_1855P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUVHjiwdmEQWDXROgAQK1JA//Th3AfhCSO/5WoSPMKNVcvnyoap6MuI5K
MWW66Nf7ZpzxNN77Jaa5+wxvBLhA9fvhAKgEB5Bj3IqsCuE94Z9vuBKT/e5J2aDv
tA9P+7o3tsWsGUFfdT7YR/ttpZ5rmVwuxEDbS+sJ65EO0MxMnkZLXgRdgOFNCnrV
VbTSHflHEgnAQL6+bN6ZxEuJusslytOEy4VpV5aVvAKhEy3RGLpPNK3db8/sRtQO
3ZMteLM5dWZ+f+o9i/w4+u58wmlTn1iBXsG0WgItn0VLatGd0q3FTZsNXXw517JH
E9dVidStaBYWASGO/XQpPObQsycpvSEVqxiWUelmQNNOQzGKwz5MQQXeyNRGiD5C
YUbUQ05HBwk4jBqpxlv9WdV+M/LdQYfRJ4GWvEZFOGjke6bKE6/g/YSWQ/iVFlT1
/Rbr3j5yi6I1nqkt/iWVSsYLYaUnJN6AGMz/1QmTeAZgQzv3QxKU3O1Q+xFC4I/d
WCjZm1yL2Hk0poCzYRrJ/ENkhZNwjv2H54iwaKN/VYfVNqmP4jtqT1Xc9b6I0ApB
1pc2oR5fsjvUiuRupWFOcjQCf/AXxZSFIw6tirBN7a/k/FCGi1ZgMD+evJ0cOJNg
MeqmllYR2shpkI4F5W7BWhhHXxsrbrHzK0jXgXhZUNDnpNISw3DXfrLFRVM7RJHy
1s2J2xnIQh8=
=087u
-----END PGP SIGNATURE-----

--==_Exmh_1364321163_1855P--

