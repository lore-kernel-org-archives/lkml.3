Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbbASUzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:55:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbbASUyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:54:14 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 4/6] Input: mt: document find_reduced_matrix()
Date: Mon, 19 Jan 2015 15:53:53 -0500
Message-Id: <1421700835-22157-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_reduced_matrix() is really cryptic right now.
To try to understand what the function does, replace the variable names
with the following:
nrc -> n_elems
nr -> n_rows
nc -> n_columns

Also add a partial doc that needs to be filled by someone who knows
what the function is actually doing.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/input-mt.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index 0b98ac7..e43c33c 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -322,16 +322,32 @@ static int adjust_dual(int *begin, int step, int *end, int eq)
 	return (c < s && s <= 0) || (f >= 0 && f < c);
 }
 
-static void find_reduced_matrix(int *w, int nr, int nc, int nrc)
+/**
+ * find_reduced_matrix() -
+ * @matrix: the current reduced cost matrix (to be changed in place)
+ * @n_rows: number of rows in the matrix
+ * @n_columns: number of columns in the matrix
+ * @n_elems: number of elements in the matrix (should be n_rows * n_columns)
+ *
+ * FIXME -- can someone tell what this function does???
+ */
+static void find_reduced_matrix(int *matrix, int n_rows, int n_columns,
+		int n_elems)
 {
 	int i, k, sum;
 
-	for (k = 0; k < nrc; k++) {
-		for (i = 0; i < nr; i++)
-			adjust_dual(w + i, nr, w + i + nrc, nr <= nc);
+	for (k = 0; k < n_elems; k++) {
+		for (i = 0; i < n_rows; i++)
+			adjust_dual(matrix + i,
+				    n_rows,
+				    matrix + i + n_elems,
+				    n_rows <= n_columns);
 		sum = 0;
-		for (i = 0; i < nrc; i += nr)
-			sum += adjust_dual(w + i, 1, w + i + nr, nc <= nr);
+		for (i = 0; i < n_elems; i += n_rows)
+			sum += adjust_dual(matrix + i,
+					   1,
+					   matrix + i + n_rows,
+					   n_columns <= n_rows);
 		if (!sum)
 			break;
 	}
-- 
2.1.0

