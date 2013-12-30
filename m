Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab3L3XUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 18:20:20 -0500
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:22663 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab3L3XUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 18:20:18 -0500
Date: Mon, 30 Dec 2013 15:20:10 -0800
From: Stephen Hemminger <shemming@brocade.com>
To: David Howells <dhowells@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <keyrings@linux-nfs.org>
Subject: [PATCH] assoc_array: remove global variable
Message-ID: <20131230152010.2d26d75b@nehalam.linuxnetplumber.net>
Organization: Brocade
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-30_02:2013-12-30,2013-12-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1312300170
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The associative array code creates unnecessary and potentially problematic
global variable 'status'. Remove it since never used.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

--- a/lib/assoc_array.c	2013-12-20 07:59:47.468147094 -0800
+++ b/lib/assoc_array.c	2013-12-30 15:14:38.034880698 -0800
@@ -157,7 +157,7 @@ enum assoc_array_walk_status {
 	assoc_array_walk_tree_empty,
 	assoc_array_walk_found_terminal_node,
 	assoc_array_walk_found_wrong_shortcut,
-} status;
+};
 
 struct assoc_array_walk_result {
 	struct {
