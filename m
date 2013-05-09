Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3EIH7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:59:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56751 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3EIH7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:59:33 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-c4-518b576349c1
Date: Thu, 09 May 2013 07:59:31 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
To: tytso@mit.edu, linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130509074454754@eunb.song
Msgkey: 20130509074454754@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130509074454754@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15102321.375241368086369792.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zjm5yeHegwdoNPBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj8+tuxoIn/BU/juxhbWBcw9/FyMkhJKAi0fL/OyOILSFgIvFh
	+iEoW0ziwr31bF2MXEA1yxgl/l/qYIYpWrr3CDNEYj6jxPHmjywgCRagSSumvWIHsdkEtCXe
	fnnA2sXIwSEsYCfx8rkTSFhEoErieO9uJojF8hKTT18GK+cVEJQ4OfMJC8R8JYl1DY1sEHFl
	ic+P/zBBxCUkZk2/wAph80rMaH8KVS8nMe3rGqjbpCXOz9oA98Di74+h4vwSx27vYAI5B6T3
	yf1gmDG7N39hg7AFJKaeOQjVqi7x6Vo7VJxPYs3CtywwY3adWs4M03t/y1yw05gFFCWmdD9k
	h7C1JL782MeG7i1eASeJr1PPgsNTQmAqh8TKWfdZJjAqzUJSNwvJrFlIZiGrWcDIsopRNLUg
	uaA4Kb3ISK84Mbe4NC9dLzk/dxMjJDH07WC8ecD6EGMyMEomMkuJJucDE0teSbyhsZmRhamJ
	qbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjFLtx/aaqaIlTyjc2L
	W8+zeN5f9fhnC6e9Pt1XvzT7xtUJHE82HTa6dv9CfMuPbfPvtuTNS3kYqBPHdbvne6Mm2/fA
	6Rff8vnc7XaWsJz7PnyKs8C/3lNlDUo+X959eD8p+un7Sb91o74bqJ7et5DV9bPr1nMcPeKG
	93/Ne3J4/Xxv67ctbowflViKMxINtZiLihMBbPwDLCIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t/tmbrJ4d2BBg/+clhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jM+vuxkLnvBX/Diyh7WBcQ1/FyMnh5CAikTL/++MILaEgInE0r1HmCFsMYkL99azdTFyAdXM
	Z5Q43vyRBSTBAtSwYtordhCbTUBb4u2XB6xdjBwcwgJ2Ei+fO4GERQSqJI737maCmC8vMfn0
	ZbByXgFBiZMzn7BAzFeSWNfQyAYRV5b4/PgPE0RcQmLW9AusEDavxIz2p1D1chLTvq6Buk1a
	4vysDYwwdy7+/hgqzi9x7PYOJpBzQHqf3A+GGbN78xc2CFtAYuqZg1Ct6hKfrrVDxfkk1ix8
	ywIzZtep5cwwvfe3zAU7jVlAUWJK90N2CFtL4suPfWzo3uIVcJL4OvUs2wRG2VlIUrOQtM9C
	0o6sZgEjyypG0dSC5ILipPQKI73ixNzi0rx0veT83E2M4ET0bNEOxn/nrQ8xCnAwKvHwZiR2
	BQqxJpYVV+YeYpTgYFYS4T3m1h0oxJuSWFmVWpQfX1Sak1p8iDEZGGcTmaVEk/OBSTKvJN7Q
	2MDY0NDS3MDU0MiCNGElcd5nrdaBQgLpiSWp2ampBalFMFuYODilGhjj7//b9msjn2fUnq0f
	Ba+0fv7eeer/YWmnbdenMjDM8zeN5z/KaX3uZry9nWlG4wSjZ96MtUdXbLnJtr5Y5Y7Wf62E
	R5FHLl6ZsN2kotivy9bSsF/jxIQtUv6e+grtkkYZky13Xvhi8Snn6+qYj+JvZSxbch9k79EM
	yN9t8f7a56q1FhtMGzuVWIozEg21mIuKEwEJjVwbiAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r497xioN013957


Hello.
In my board, i ran the iozone with multi-thread option. 
My board has 8 cores and i enabled CONFIG_SMP. 
the iozone command as follow: iozone -l 20 -u 20 -r 64k -s 5m -o -F /user/f1 /user/f2 /user/f3 /user/f4 /user/f5 /user/f6 /user/f7 /user/f8 /user/f9 /user/f10 /user/f11 /user/f12 /user/f13 /user/f14 /user/f15 /user/f16 /user/f17 /user/f18 /user/f19 /user/f20

mount info as follow
cat /proc/mounts
/dev/sda3 /user ext4 rw,noatime,nodiratime,errors=panic,barrier=1,data=ordered 0 0

I got a message as below every time i ran iozone test. 


[ 4876.293124] [<ffffffff80272d18>] show_stack+0x68/0x80
[ 4876.309411] [<ffffffff802bde4c>] notifier_call_chain+0x5c/0xa8
[ 4876.315245] [<ffffffff802be524>] __atomic_notifier_call_chain+0x3c/0x58
[ 4876.321860] [<ffffffff802be588>] notify_die+0x38/0x48
[ 4876.326913] [<ffffffff80272548>] do_trap_or_bp+0x48/0x1a8
[ 4876.332312] [<ffffffff8026cfe4>] resume_userspace_check+0x0/0x10
[ 4876.338323] [<ffffffff80462994>] jbd2_journal_put_journal_head+0xcc/0x250
[ 4876.345111] [<ffffffff804603b4>] __jbd2_journal_remove_checkpoint+0x54/0x130
[ 4876.352160] [<ffffffff8045e630>] jbd2_journal_commit_transaction+0x1318/0x1ad0
[ 4876.359383] [<ffffffff80463f4c>] kjournald2+0x114/0x450
[ 4876.364611] [<ffffffff802b8160>] kthread+0xb8/0xc0
[ 4876.369402] [<ffffffff8026d060>] ret_from_kernel_thread+0x10/0x18

When i ran without multi-thread option, the problem was not ocurred.


Thanks. 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
