Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3E0AYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 20:24:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53949 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3E0AYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 20:24:01 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-60-51a2a79fe0ee
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Trond Myklebust'" <Trond.Myklebust@netapp.com>,
        "'Andy Adamson'" <andros@netapp.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] NFSv4.1 Fix a pNFS session draining deadlock
Date: Mon, 27 May 2013 09:23:59 +0900
Message-id: <000001ce5a70$7b9bd410$72d37c30$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkhkJMA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfd35yxcFGixfaW3xcraIxZJmbovL
	u+awWSzY+IjR4ujkJAdWjxmfvrB59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bOl+sYC7bb
	VEy/foqlgfGFURcjJ4eEgInE7o9z2SFsMYkL99azdTFycQgJLGOU6Lj5nB2maOnLCywQiUWM
	Eo3fdkFV/WWUeDHnDDNIFZuArsSx9VtYQWwRAW+JU1N+gcWZBQokbq69BBTnAGrglljdHAQS
	5hTgkVj3pxOsRFjAQ+LS6zMsIDaLgKrEp+sHGUFsXgE7iY2/Z7ND2IISPybfY4EYqSWxfudx
	JghbXmLzmrfMIOMlBNQlHv3VBTlNRKCBUeLVjD6oE0Qk9r14xwiSkBA4xS7xd20jK8QyAYlv
	kw+xQDTLSmw6wAzxsKTEwRU3WCYwSsxCsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UUmesWJ
	ucWleel6yfm5mxghETlhB+O9A9aHGJOB1k9klhJNzgdGdF5JvKGxmZGFqYmpsZG5pRlpwkri
	vOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGOUmf9K20Uj7231DaCtLjsz7w+q3uB+6
	7ROs2HT+1FFnzU/P7sqeeJYULit86Vjv3ZKEQ5t2aTBG2LS6WYq59wvW2zpHXNgy4+T7cyHH
	z3Wpvre6fGPz9qfFjROE4vLmyHp1rDgTqrH85LQ0eUvv825llrs9jkfJzOsNnNQVvyh15eLp
	lh/NUpRYijMSDbWYi4oTAcYNEcHeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd35yxcFGrTOMbN4OVvEYkkzt8Xl
	XXPYLBZsfMRocXRykgOrx4xPX9g8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7
	ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ihkkJZYk4pUCggsbhYSd8O04TQEDddC5jG
	CF3fkCC4HiMDNJCwjjFj58t1jAXbbSqmXz/F0sD4wqiLkZNDQsBEYunLCywQtpjEhXvr2boY
	uTiEBBYxSjR+2wXl/GWUeDHnDDNIFZuArsSx9VtYQWwRAW+JU1N+gcWZBQokbq69BBTnAGrg
	lljdHAQS5hTgkVj3pxOsRFjAQ+LS6zNgy1gEVCU+XT/ICGLzCthJbPw9mx3CFpT4MfkeC8RI
	LYn1O48zQdjyEpvXvGUGGS8hoC7x6K8uyGkiAg2MEq9m9EGdICKx78U7xgmMQrOQjJqFZNQs
	JKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM43p9J72Bc1WBxiFGAg1GJh3fB
	jEWBQqyJZcWVuYcYJTiYlUR4E6KBQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTEV5JfGG
	xiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cAo+avoztPijsPv7+hm
	TL99f9XTpHzV36mBNn1f2SymXnl+1qxxxhfmST6bX1vtfrK2atGRzMLykBm1hxViPylPXM3X
	vHnZf+ULsvenCt/hvC64xszq5LEvQdIVMleaYp61Plml3bIq3Nsnf8VZVb6qBTu3nf5fnFfy
	JUn6+tnViTwMoevZHjzKVWIpzkg01GIuKk4EALbZKDM7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Andy Adamson <andros@netapp.com>"

commit 774d5f14ee1ecac55f42a84ff35eb00b896b00b6 upstream

On a CB_RECALL the callback service thread flushes the inode using
filemap_flush prior to scheduling the state manager thread to return the
delegation. When pNFS is used and I/O has not yet gone to the data server
servicing the inode, a LAYOUTGET can preceed the I/O. Unlike the async
filemap_flush call, the LAYOUTGET must proceed to completion.

If the state manager starts to recover data while the inode flush is sending
the LAYOUTGET, a deadlock occurs as the callback service thread holds the
single callback session slot until the flushing is done which blocks the
state
manager thread, and the state manager thread has set the session draining
bit
which puts the inode flush LAYOUTGET RPC to sleep on the forechannel slot
table waitq.

Separate the draining of the back channel from the draining of the fore
channel
by moving the NFS4_SESSION_DRAINING bit from session scope into the fore
and back slot tables.  Drain the back channel first allowing the LAYOUTGET
call to proceed (and fail) so the callback service thread frees the callback
slot. Then proceed with draining the forechannel.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 fs/nfs/callback_proc.c |    2 +-
 fs/nfs/callback_xdr.c  |    2 +-
 fs/nfs/nfs4proc.c      |    2 +-
 fs/nfs/nfs4session.c   |    4 ++--
 fs/nfs/nfs4session.h   |   13 ++++++++-----
 fs/nfs/nfs4state.c     |   15 +++++++--------
 6 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 2960512..339bfa3 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -414,7 +414,7 @@ __be32 nfs4_callback_sequence(struct cb_sequenceargs
*args,
 
 	spin_lock(&tbl->slot_tbl_lock);
 	/* state manager is resetting the session */
-	if (test_bit(NFS4_SESSION_DRAINING,
&clp->cl_session->session_state)) {
+	if (test_bit(NFS4_SLOT_TBL_DRAINING, &tbl->slot_tbl_state)) {
 		spin_unlock(&tbl->slot_tbl_lock);
 		status = htonl(NFS4ERR_DELAY);
 		/* Return NFS4ERR_BADSESSION if we're draining the session
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 59461c9..a35582c 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -763,7 +763,7 @@ static void nfs4_callback_free_slot(struct nfs4_session
*session)
 	 * A single slot, so highest used slotid is either 0 or -1
 	 */
 	tbl->highest_used_slotid = NFS4_NO_SLOT;
-	nfs4_session_drain_complete(session, tbl);
+	nfs4_slot_tbl_drain_complete(tbl);
 	spin_unlock(&tbl->slot_tbl_lock);
 }
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 0086401..beb807c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -559,7 +559,7 @@ int nfs41_setup_sequence(struct nfs4_session *session,
 	task->tk_timeout = 0;
 
 	spin_lock(&tbl->slot_tbl_lock);
-	if (test_bit(NFS4_SESSION_DRAINING, &session->session_state) &&
+	if (test_bit(NFS4_SLOT_TBL_DRAINING, &tbl->slot_tbl_state) &&
 	    !args->sa_privileged) {
 		/* The state manager will wait until the slot table is empty
*/
 		dprintk("%s session is draining\n", __func__);
diff --git a/fs/nfs/nfs4session.c b/fs/nfs/nfs4session.c
index ebda5f4..c4e225e 100644
--- a/fs/nfs/nfs4session.c
+++ b/fs/nfs/nfs4session.c
@@ -73,7 +73,7 @@ void nfs4_free_slot(struct nfs4_slot_table *tbl, struct
nfs4_slot *slot)
 			tbl->highest_used_slotid = new_max;
 		else {
 			tbl->highest_used_slotid = NFS4_NO_SLOT;
-			nfs4_session_drain_complete(tbl->session, tbl);
+			nfs4_slot_tbl_drain_complete(tbl);
 		}
 	}
 	dprintk("%s: slotid %u highest_used_slotid %d\n", __func__,
@@ -226,7 +226,7 @@ static bool nfs41_assign_slot(struct rpc_task *task,
void *pslot)
 	struct nfs4_slot *slot = pslot;
 	struct nfs4_slot_table *tbl = slot->table;
 
-	if (nfs4_session_draining(tbl->session) && !args->sa_privileged)
+	if (nfs4_slot_tbl_draining(tbl) && !args->sa_privileged)
 		return false;
 	slot->generation = tbl->generation;
 	args->sa_slot = slot;
diff --git a/fs/nfs/nfs4session.h b/fs/nfs/nfs4session.h
index 6f3cb39..ff7d9f0 100644
--- a/fs/nfs/nfs4session.h
+++ b/fs/nfs/nfs4session.h
@@ -25,6 +25,10 @@ struct nfs4_slot {
 };
 
 /* Sessions */
+enum nfs4_slot_tbl_state {
+	NFS4_SLOT_TBL_DRAINING,
+};
+
 #define SLOT_TABLE_SZ DIV_ROUND_UP(NFS4_MAX_SLOT_TABLE, 8*sizeof(long))
 struct nfs4_slot_table {
 	struct nfs4_session *session;		/* Parent session */
@@ -43,6 +47,7 @@ struct nfs4_slot_table {
 	unsigned long	generation;		/* Generation counter for
 						   target_highest_slotid */
 	struct completion complete;
+	unsigned long	slot_tbl_state;
 };
 
 /*
@@ -68,7 +73,6 @@ struct nfs4_session {
 
 enum nfs4_session_state {
 	NFS4_SESSION_INITING,
-	NFS4_SESSION_DRAINING,
 };
 
 #if defined(CONFIG_NFS_V4_1)
@@ -88,12 +92,11 @@ extern void nfs4_destroy_session(struct nfs4_session
*session);
 extern int nfs4_init_session(struct nfs_server *server);
 extern int nfs4_init_ds_session(struct nfs_client *, unsigned long);
 
-extern void nfs4_session_drain_complete(struct nfs4_session *session,
-		struct nfs4_slot_table *tbl);
+extern void nfs4_slot_tbl_drain_complete(struct nfs4_slot_table *tbl);
 
-static inline bool nfs4_session_draining(struct nfs4_session *session)
+static inline bool nfs4_slot_tbl_draining(struct nfs4_slot_table *tbl)
 {
-	return !!test_bit(NFS4_SESSION_DRAINING, &session->session_state);
+	return !!test_bit(NFS4_SLOT_TBL_DRAINING, &tbl->slot_tbl_state);
 }
 
 bool nfs41_wake_and_assign_slot(struct nfs4_slot_table *tbl,
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index d41a351..0fc5f0f 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -253,7 +253,7 @@ static void nfs4_end_drain_session(struct nfs_client
*clp)
 	if (ses == NULL)
 		return;
 	tbl = &ses->fc_slot_table;
-	if (test_and_clear_bit(NFS4_SESSION_DRAINING, &ses->session_state))
{
+	if (test_and_clear_bit(NFS4_SLOT_TBL_DRAINING,
&tbl->slot_tbl_state)) {
 		spin_lock(&tbl->slot_tbl_lock);
 		nfs41_wake_slot_table(tbl);
 		spin_unlock(&tbl->slot_tbl_lock);
@@ -263,15 +263,15 @@ static void nfs4_end_drain_session(struct nfs_client
*clp)
 /*
  * Signal state manager thread if session fore channel is drained
  */
-void nfs4_session_drain_complete(struct nfs4_session *session,
-		struct nfs4_slot_table *tbl)
+void nfs4_slot_tbl_drain_complete(struct nfs4_slot_table *tbl)
 {
-	if (nfs4_session_draining(session))
+	if (nfs4_slot_tbl_draining(tbl))
 		complete(&tbl->complete);
 }
 
-static int nfs4_wait_on_slot_tbl(struct nfs4_slot_table *tbl)
+static int nfs4_drain_slot_tbl(struct nfs4_slot_table *tbl)
 {
+	set_bit(NFS4_SLOT_TBL_DRAINING, &tbl->slot_tbl_state);
 	spin_lock(&tbl->slot_tbl_lock);
 	if (tbl->highest_used_slotid != NFS4_NO_SLOT) {
 		INIT_COMPLETION(tbl->complete);
@@ -287,13 +287,12 @@ static int nfs4_begin_drain_session(struct nfs_client
*clp)
 	struct nfs4_session *ses = clp->cl_session;
 	int ret = 0;
 
-	set_bit(NFS4_SESSION_DRAINING, &ses->session_state);
 	/* back channel */
-	ret = nfs4_wait_on_slot_tbl(&ses->bc_slot_table);
+	ret = nfs4_drain_slot_tbl(&ses->bc_slot_table);
 	if (ret)
 		return ret;
 	/* fore channel */
-	return nfs4_wait_on_slot_tbl(&ses->fc_slot_table);
+	return nfs4_drain_slot_tbl(&ses->fc_slot_table);
 }
 
 static void nfs41_finish_session_reset(struct nfs_client *clp)
-- 
1.7.9.5

