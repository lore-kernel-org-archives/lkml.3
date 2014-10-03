Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaJCJLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:11:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52507 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJCJKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:10:05 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f7-542e67ea9598
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        jmorris@namei.org, rusty@rustcorp.com.au, keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/4] KEYS: handle error code encoded in pointer
Date: Fri, 03 Oct 2014 12:09:54 +0300
Message-id: <c772cac8c103bbb734a4614d5338ae7cdf4803d9.1412327306.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7qv0vVCDKaeZbW49Xcvs8W7pt8s
	Fl+W1lmsW7+YyWL2rocsFi9nzGO3uLxrDpvFh55HbBY3p11gsfi0YhKzA5fHzll32T2mnVjG
	4vHg0GYWj90LPjN59HxP9ni/7yqbx4oNJ5g9+rasYvT4vEkugDOKyyYlNSezLLVI3y6BK2Pa
	Ca6CboWK+SufsTUwPpfuYuTkkBAwkWifcIEdwhaTuHBvPVsXIxeHkMBSRonZVyczQzidTBKz
	W+axglSxCehJbGj+wQ6SEBE4yigx7cx1sASzQLrEp0m9YKOEBewl2ho6mEFsFgFViRVfXrGA
	2LwCcRKn9p1ghlgnJ3Hy2GSwXk4BK4ktVzewgdhCApYS6/tXsOMSn8DIv4CRYRWjaGppckFx
	UnqukV5xYm5xaV66XnJ+7iZGSCB/3cG49JjVIUYBDkYlHt4PN3RDhFgTy4orcw8xSnAwK4nw
	no7TCxHiTUmsrEotyo8vKs1JLT7EyMTBKdXAOGnH1h2L7ld9OXxKSVjrwXwNwbqSZcuEVMK2
	mZwtiPAPkqnrbbS43udu/NqhuP7IZJ9v02ez7Dh9u5NLWd790I+7D6dp9fTervpTYXLh6d4n
	DMuSM6fcOP7LmDlhWgbDtx8dponXr0z+V3DrfmnZac+cCQyiE247iHndrJqiZuW0LWFf0Opn
	KUosxRmJhlrMRcWJAAq0YqhCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If hexlen is odd then function returns an error.
Use IS_ERR to check for error, otherwise invalid pointer
is used and kernel gives oops:

[  132.816522] BUG: unable to handle kernel paging request at
ffffffffffffffea
[  132.819902] IP: [<ffffffff812bfc20>] asymmetric_key_id_same+0x14/0x36
[  132.820302] PGD 1a12067 PUD 1a14067 PMD 0
[  132.820302] Oops: 0000 [#1] SMP
[  132.820302] Modules linked in: bridge(E) stp(E) llc(E) evdev(E)
serio_raw(E) i2c_piix4(E) button(E) fuse(E)
[  132.820302] CPU: 0 PID: 2993 Comm: cat Tainted: G            E
3.16.0-kds+ #2847
[  132.820302] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  132.820302] task: ffff88004249a430 ti: ffff880056640000 task.ti:
ffff880056640000
[  132.820302] RIP: 0010:[<ffffffff812bfc20>]  [<ffffffff812bfc20>]
asymmetric_key_id_same+0x14/0x36
[  132.820302] RSP: 0018:ffff880056643930  EFLAGS: 00010246
[  132.820302] RAX: 0000000000000000 RBX: ffffffffffffffea RCX:
ffff880056643ae0
[  132.820302] RDX: 000000000000005e RSI: ffffffffffffffea RDI:
ffff88005bac9300
[  132.820302] RBP: ffff880056643948 R08: 0000000000000003 R09:
00000007504aa01a
[  132.820302] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff88005d68ca40
[  132.820302] R13: 0000000000000101 R14: 0000000000000000 R15:
ffff88005bac5280
[  132.820302] FS:  00007f67a153c740(0000) GS:ffff88005da00000(0000)
knlGS:0000000000000000
[  132.820302] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  132.820302] CR2: ffffffffffffffea CR3: 000000002e663000 CR4:
00000000000006f0
[  132.820302] Stack:
[  132.820302]  ffffffff812bfc66 ffff880056643ae0 ffff88005bac5280
ffff880056643958
[  132.820302]  ffffffff812bfc9d ffff880056643980 ffffffff812971d9
ffff88005ce930c1
[  132.820302]  ffff88005ce930c0 0000000000000000 ffff8800566439c8
ffffffff812fb753
[  132.820302] Call Trace:
[  132.820302]  [<ffffffff812bfc66>] ? asymmetric_match_key_ids+0x24/0x42
[  132.820302]  [<ffffffff812bfc9d>] asymmetric_key_cmp+0x19/0x1b
[  132.820302]  [<ffffffff812971d9>] keyring_search_iterator+0x74/0xd7
[  132.820302]  [<ffffffff812fb753>] assoc_array_subtree_iterate+0x67/0xd2
[  132.820302]  [<ffffffff81297165>] ? key_default_cmp+0x20/0x20
[  132.820302]  [<ffffffff812fbaa1>] assoc_array_iterate+0x19/0x1e
[  132.820302]  [<ffffffff81297332>] search_nested_keyrings+0xf6/0x2b6
[  132.820302]  [<ffffffff810728da>] ? sched_clock_cpu+0x91/0xa2
[  132.820302]  [<ffffffff810860d2>] ? mark_held_locks+0x58/0x6e
[  132.820302]  [<ffffffff810a137d>] ? current_kernel_time+0x77/0xb8
[  132.820302]  [<ffffffff81297871>] keyring_search_aux+0xe1/0x14c
[  132.820302]  [<ffffffff812977fc>] ? keyring_search_aux+0x6c/0x14c
[  132.820302]  [<ffffffff8129796b>] keyring_search+0x8f/0xb6
[  132.820302]  [<ffffffff812bfc84>] ? asymmetric_match_key_ids+0x42/0x42
[  132.820302]  [<ffffffff81297165>] ? key_default_cmp+0x20/0x20
[  132.820302]  [<ffffffff812ab9e3>] asymmetric_verify+0xa4/0x214
[  132.820302]  [<ffffffff812ab90e>] integrity_digsig_verify+0xb1/0xe2
[  132.820302]  [<ffffffff812abe41>] ? evm_verifyxattr+0x6a/0x7a
[  132.820302]  [<ffffffff812b0390>] ima_appraise_measurement+0x160/0x370
[  132.820302]  [<ffffffff81161db2>] ? d_absolute_path+0x5b/0x7a
[  132.820302]  [<ffffffff812ada30>] process_measurement+0x322/0x404

Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 crypto/asymmetric_keys/asymmetric_type.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index f0f2111..29983cb 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -153,8 +153,8 @@ static int asymmetric_key_match_preparse(struct key_match_data *match_data)
 	}
 
 	match_id = asymmetric_key_hex_to_key_id(id);
-	if (!match_id)
-		return -ENOMEM;
+	if (IS_ERR(match_id))
+		return PTR_ERR(match_id);
 
 	match_data->preparsed = match_id;
 	match_data->cmp = asymmetric_key_cmp;
-- 
1.9.1

