Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3EHWsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:48:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28000 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3EHWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:48:17 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-cc-518ad62faf8e
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Lars Ellenberg'" <lars.ellenberg@linbit.com>,
        "'Philipp Reisner'" <philipp.reisner@linbit.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] drbd: fix memory leak
Date: Thu, 09 May 2013 07:48:15 +0900
Message-id: <003301ce4c3e$207b06e0$617114a0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACKxITw
x-cr-hashedpuzzle: CONX DpG2 EyZz GMfF KXw3 KvuM UYMd dzt6 fFxa pKoN q1Ql rIEM
 2l59 366t 4VbE
 6QS/;5;agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABhAHIAcwAuAGUAbABsAGUAbgBiAGUAcgBnAEAAbABpAG4AYgBpAHQALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBwAGgAaQBsAGkAcABwAC4AcgBlAGkAcwBuAGUAcgBAAGwAaQBuAGIAaQB0AC4AYwBvAG0AOwBzAHQAYQBiAGwAZQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{E885D32F-2490-4E34-A141-A0AD776D4FAB};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Wed,
 08 May 2013 22:48:05
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOQAtAHMAdABhAGIAbABlAF0AIABkAHIAYgBkADoAIABmAGkAeAAgAG0AZQBtAG8AcgB5ACAAbABlAGEAawA=
x-cr-puzzleid: {E885D32F-2490-4E34-A141-A0AD776D4FAB}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zY139a12BBvs+G1ssaea2mN/9nsXi
	8q45bBYvZz5msliw8RGjA6vH0ytHmDz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4/KEP4wF
	qzkqdmzdytzAOIG9i5GTQ0LARGLajofMELaYxIV769m6GLk4hASWMUo8nvybDabo+9vPTBCJ
	6YwS39ctY4dw/jJKnLu8HaydTUBX4tj6LawgtoiAt8SpKb/A4swCVRKf+zpZuhg5gBq4JVY3
	B4GEOQV4JNb96WQGCQsLGErs/akPEmYRUJV4t+IdI4jNK2An8XnOD3YIW1Dix+R7LBATtSQ2
	b2tihbDlJTaveQs2RkJAXeLRX12IsIjEvhcQY0QEYiRWNrwE+0tC4AirxN4pPSwQf5lKvH4z
	kxEi8ZJdom3zPDaIIwQkvk0+xAIxVFZi0wFoAElKHFxxg2UCo9QsJCfNQnLSLCQnzUJyxwJG
	llWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYITHct4Px5gHrQ4zJQOsnMkuJJucDU0BeSbyh
	sZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgzrGbs4pOu
	rX05d39ssWv/W4ecX+teVmUElV0yFtyhqbJVtuXguiuGs2SVhbJP3Z0cNv+98quI5ouVW4x0
	D8+SW/TYcVX+FOUDT1a01dWyCDc1v3WSlemrnRdvdtv7Mfd7dvebPOL2D4TfHdZqlZmmV5K4
	IHfatQ0yf1u/SjZNuLps3VYVBU4lluKMREMt5qLiRAAzw7pI9wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQV39a12BBs1NBhZLmrkt5ne/Z7G4
	vGsOm8XLmY+ZLBZsfMTowOrx9MoRJo++LasYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqmkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzLg84Q9jwWqOih1btzI3ME5g72Lk5JAQMJH4/vYzE4QtJnHh3nq2
	LkYuDiGB6YwS39ctY4dw/jJKnLu8nRmkik1AV+LY+i2sILaIgLfEqSm/wOLMAlUSn/s6WboY
	OYAauCVWNweBhDkFeCTW/elkBgkLCxhK7P2pDxJmEVCVeLfiHSOIzStgJ/F5zg92CFtQ4sfk
	eywQE7UkNm9rYoWw5SU2r3kLNkZCQF3i0V9diLCIxL4XEGNEBGIkVja8BDtfQuAIq8TeKT0s
	EH+ZSrx+M5NxAqPILCQrZiFZMQvJillI5i5gZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJ
	EZwgnknvYFzVYHGIUYCDUYmHNyOxK1CINbGsuDL3EKMEB7OSCO/dVqAQb0piZVVqUX58UWlO
	avEhxmRgCExklhJNzgcmr7ySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbB
	bGHi4JRqYHSb90BCnvke80PnB5lydh6fc/a+rzGTula5esUCqz2CNjz6VVPfvhQP0zISOBB/
	eH3nK7F1MxwXt6l05yw6HSC5xzhDwN2M2ddi0g8/1qNb0ybZLr22veKP4trJpsdnafzQ/7wh
	8eeysxvWO1tYuJS07rrwMeXZwu+/mG5KdNx9XlzayLEzllGJpTgj0VCLuag4EQA5p9/KVAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Lars Ellenberg <lars.ellenberg@linbit.com>"

commit 94ad0a101415978be04945b2787be1e8e8a874db upstream

We forgot to free the disk_conf,
so for each attach/detach cycle we leaked 336 bytes.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/block/drbd/drbd_main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e98da67..54d03d4 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2795,6 +2795,7 @@ void drbd_free_bc(struct drbd_backing_dev *ldev)
 	blkdev_put(ldev->backing_bdev, FMODE_READ | FMODE_WRITE |
FMODE_EXCL);
 	blkdev_put(ldev->md_bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 
+	kfree(ldev->disk_conf);
 	kfree(ldev);
 }


