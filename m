Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaBTKfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:35:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:48586 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbaBTKfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:35:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,512,1389772800"; 
   d="scan'208,223";a="412316373"
From: "Compostella\, Jeremy" <jeremy.compostella@intel.com>
To: devel@driverdev.osuosl.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] Android / binder: Fix broken walk in binder_node_release()
CC: "Gross, Mark" <mark.gross@intel.com>, "Ernst, Eric" <eric.ernst@intel.com>,
        "Arve" <arve@android.com>
Date: Thu, 20 Feb 2014 11:35:04 +0100
Message-ID: <87eh2yxeav.fsf@tldlab276.tl.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksCgpJJ3ZlIGZvdW5kIGEgYnVnIGluIHRoZSBiaW5kZXIgZHJpdmVyIGFuZCBJIHByb3Bvc2Ug
dGhlIGF0dGFjaGVkIHBhdGNoIHRvIGZpeAppdC4gIFRoaXMgYnVnIGNvdWxkIG1hbmlmZXN0IGl0
c2VsZiBpbiBzZXZlcmFsIHNpdHVhdGlvbnMsIGhlcmUgaXMgdGhlIG9uZSB0aGF0Cm1hZGUgbWUg
aHVudCBpdCBsYXN0IHdlZWsuCgpXaGVuIGFuIEFuZHJvaWQgZGV2aWNlIGlzIGVuY3J5cHRlZCwg
QW5kcm9pZCBzdGFydHMgYWxsIHRoZSBpbml0IHNlcnZpY2VzIG9mCmNvcmUgYW5kIG1haW4gbGV2
ZWxzLCB0aGVuIGl0IGFza3MgZm9yIHRoZSBwYXNzd29yZCBhbmQgY2hlY2tzIGl0IHRyeWluZyB0
bwptb3VudCAvZGF0YS4gIE9uIHN1Y2Nlc3MsIGl0IGtpbGxzIGFsbCB0aGUgbWFpbiBzZXJ2aWNl
cywgbW91bnQgL2RhdGEgYW5kCnJlc3RhcnQgYWxsIHRoZSBtYWluIHNlcnZpY2VzLgoKVW5mb3J0
dW5hdGVseSwgb24gcmVzdGFydCBvZiB0aG9zZSBtYWluIHNlcnZpY2VzIHdlIG9ic2VydmUgOgoK
RGlzcGxheU1hbmFnZXIgICAgICAgQ291bGQgbm90IGdldCBkaXNwbGF5IGluZm9ybWF0aW9uIGZy
b20gZGlzcGxheSBtYW5hZ2VyLgpEaXNwbGF5TWFuYWdlciAgICAgICBhbmRyb2lkLm9zLkRlYWRP
YmplY3RFeGNlcHRpb24KRGlzcGxheU1hbmFnZXIgICAgICAgYXQgYW5kcm9pZC5vcy5CaW5kZXJQ
cm94eS50cmFuc2FjdChOYXRpdmUgTWV0aG9kKQpEaXNwbGF5TWFuYWdlciAgICAgICBhdCBhbmRy
b2lkLmhhcmR3YXJlLmRpc3BsYXkuSURpc3BsYXlNYW5hZ2VyJFN0dWIkUHJveHkuZ2V0RGlzcGxh
eUluZm8oSURpc3BsYXlNYW5hZ2VyLmphdmE6MjI4KQpEaXNwbGF5TWFuYWdlciAgICAgICBhdCBh
bmRyb2lkLmhhcmR3YXJlLmRpc3BsYXkuRGlzcGxheU1hbmFnZXJHbG9iYWwuZ2V0RGlzcGxheUlu
Zm8oRGlzcGxheU1hbmFnZXJHbG9iYWwuamF2YToxMTcpCkRpc3BsYXlNYW5hZ2VyICAgICAgIGF0
IGFuZHJvaWQuaGFyZHdhcmUuZGlzcGxheS5EaXNwbGF5TWFuYWdlckdsb2JhbC5nZXRDb21wYXRp
YmxlRGlzcGxheShEaXNwbGF5TWFuYWdlckdsb2JhbC5qYXZhOjE3NikKRGlzcGxheU1hbmFnZXIg
ICAgICAgYXQgYW5kcm9pZC5hcHAuUmVzb3VyY2VzTWFuYWdlci5nZXREaXNwbGF5TWV0cmljc0xv
Y2tlZChSZXNvdXJjZXNNYW5hZ2VyLmphdmE6OTYpCkRpc3BsYXlNYW5hZ2VyICAgICAgIGF0IGFu
ZHJvaWQuYXBwLlJlc291cmNlc01hbmFnZXIuZ2V0RGlzcGxheU1ldHJpY3NMb2NrZWQoUmVzb3Vy
Y2VzTWFuYWdlci5qYXZhOjc0KQpbLi4uXQoKV2hpY2ggbWVhbnMgdGhhdCB0aGUgJ2Rpc3BsYXkn
IHNlcnZpY2UgaXMgcmVnaXN0ZXJlZCBpbnRvIHRoZSBzZXJ2aWNlX21hbmFnZXIKYnV0IHBvaW50
IHRvIGEgZGVhZCBvYmplY3QgKHVuZGVyc3RhbmQgZGllZCBwcm9jZXNzKS4gIFRoaXMgZXJyb3Ig
aXMgdGhlIGZpcnN0Cm9uZSBvZiBhIGNoYWluIG9mIG1pc3NpbmcgInJlbW90ZSIgb2JqZWN0cyBj
YXVzaW5nIHRoZSBkZWF0aCBvZiBwcm9jZXNzZXMgdW50aWwKdGhlIHN5c3RlbSBjYW4gcmVjb3Zl
cnkgYnkgaXRzZWxmIGEgZmV3IHNlY29uZHMgbGF0ZXIuCgpUaGUgYmluZGVyIGRyaXZlciBhbGxv
d3MgYSAicHJvY2VzcyIgdG8gYXNrIGEgbm90aWZpY2F0aW9uIHdoZW4gYSBwYXJ0aWN1bGFyCnJl
ZmVyZW5jZSBkaWUuICBJbiB0aGF0IGNhc2UsIHRoZSBiaW5kZXIgZHJpdmVyIGFzc29jaWF0ZSBh
IGRlYXRoIG9iamVjdCB0byB0aGlzCnJlZmVyZW5jZS4KCldoZW4gdGhlIHN5c3RlbV9zZXJ2ZXIg
cHJvY2VzcyBkaWVkLCB0aGUgZmlsZSBkZXNjcmlwdG9yIHRvIHRoZSBiaW5kZXIgZHJpdmVyIGlz
CmF1dG9tYXRpY2FsbHkgcmVsZWFzZWQgYW5kIHRoZSBiaW5kZXIgZHJpdmVyIHdpbGwgd2FsayBh
bGwgdGhlIHJlZmVyZW5jZXMKYXNzb2NpYXRlZCB0byB0aGlzIHByb2Nlc3MgdG8gdW5hbGxvY2F0
ZSB0aGVtLiAgV2hlbiBzdWNoIGEgcmVmZXJlbmNlIGhhcyBhCmRlYXRoIG9iamVjdCBhc3NvY2lh
dGVkIGl0IHdpbGwgZXhlY3V0ZSBhIHRhc2sgdG8gbm90aWZ5IHRoZSBkZWF0aCB0byB0aGUKcHJl
dmlvdXNseSByZWdpc3RlciBwcm9jZXNzIHVzdWFsbHkgdGhlIHNlcnZpY2VfbWFuYWdlciBwcm9j
ZXNzLgoKVGhlIGJ1ZyBpcyB0aGF0IHRoaXMgd2FsayBvbiBhbGwgdGhlIHJlZmVyZW5jZXMgaXMg
YnJva2VuIGR1ZSB0byBhbgp1bmZvcm5hdGUgcmVmYWN0b3JpbmcgbWFkZSBieSB0aGUgZm9sbG93
aW5nIHBhdGNoIDoKCiAgICAgICAgY29tbWl0IDAwOGZhNzQ5ZTBmZTViMmZmZmQyMGI3ZmU0ODkx
YmI4MGQwNzJjNmEKICAgICAgICBBdXRob3I6IE1pcnNhbCBFbm5haW1lIDxtaXJzYWxAbWlyc2Fs
LmZyPgogICAgICAgIERhdGU6ICAgVHVlIE1hciAxMiAxMTo0MTo1OSAyMDEzICswMTAwCgp3aGlj
aCBicmVhayB0aGUgbG9vcCBpZiB0aGUgY3VycmVudCByZWZlcmVuY2UgZG9lcyBub3QgaGF2ZSBh
IGRlYXRoIG9iamVjdAppbnN0ZWFkIG9mIGNvbnRpbnVpbmcgdG8gdGhlIG5leHQgcmVmZXJlbmNl
LiAgQXMgYSBjb25zZXF1ZW5jZSBhbGwgdGhlIG5leHQKcmVmZXJlbmNlcyB3aWxsIG5vdCBiZSBj
b3JyZWN0bHkgdW5hbGxvY2F0ZSBhbmQgbm8gZGVhdGggbm90aWZpY2F0aW9uIHdpbGwgYmUKc2Vu
dCBmb3IgdGhlbS4KClRoYW5rcywKCkrDqXLDqW15Ci0tIApTZW50IGZyb20gbXkgRW1hY3MKLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tCkludGVsIENvcnBvcmF0aW9uIFNBUyAoRnJlbmNoIHNpbXBsaWZpZWQgam9pbnQg
c3RvY2sgY29tcGFueSkKUmVnaXN0ZXJlZCBoZWFkcXVhcnRlcnM6ICJMZXMgTW9udGFsZXRzIi0g
MiwgcnVlIGRlIFBhcmlzLCAKOTIxOTYgTWV1ZG9uIENlZGV4LCBGcmFuY2UKUmVnaXN0cmF0aW9u
IE51bWJlcjogIDMwMiA0NTYgMTk5IFIuQy5TLiBOQU5URVJSRQpDYXBpdGFsOiA0LDU3MiwwMDAg
RXVyb3MKClRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgbWF5IGNvbnRhaW4gY29uZmlk
ZW50aWFsIG1hdGVyaWFsIGZvcgp0aGUgc29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVu
dChzKS4gQW55IHJldmlldyBvciBkaXN0cmlidXRpb24KYnkgb3RoZXJzIGlzIHN0cmljdGx5IHBy
b2hpYml0ZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZApyZWNpcGllbnQsIHBsZWFzZSBj
b250YWN0IHRoZSBzZW5kZXIgYW5kIGRlbGV0ZSBhbGwgY29waWVzLgo=

--=-=-=
Content-Type: text/x-diff
Content-Disposition: attachment;
 filename=0001-Android-binder-Fix-broken-walk-in-binder_node_releas.patch
Content-Description: [PATCH] Android / binder: Fix broken walk in
 binder_node_release()

>From eaf6a8f28f02220ef2154c76a5345f6aa582e8f7 Mon Sep 17 00:00:00 2001
From: Jeremy Compostella <jeremy.compostella@intel.com>
Date: Tue, 11 Feb 2014 19:40:29 +0100
Subject: [PATCH] Android / binder: Fix broken walk in binder_node_release()

Fix an issue introduced by commit
008fa749e0fe5b2fffd20b7fe4891bb80d072c6a ("drivers: android: binder:
Move the node release code to a separate function") which move and
rework some code from binder_deferred_release to the
binder_node_release new function.  The rework introduced an
unfortunate break of the loop that prevent some death notifications to
be sent.

Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
---
 drivers/staging/android/binder.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index eaec1da..1432d95 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2904,7 +2904,7 @@ static int binder_node_release(struct binder_node *node, int refs)
 		refs++;
 
 		if (!ref->death)
-			goto out;
+			continue;
 
 		death++;
 
@@ -2917,7 +2917,6 @@ static int binder_node_release(struct binder_node *node, int refs)
 			BUG();
 	}
 
-out:
 	binder_debug(BINDER_DEBUG_DEAD_BINDER,
 		     "node %d now dead, refs %d, death %d\n",
 		     node->debug_id, refs, death);
-- 
1.7.10.4


--=-=-=--

