Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaBQVVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:21:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBQVVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:21:34 -0500
Date: Mon, 17 Feb 2014 16:21:24 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: reiserfs: fix utterly brain-damaged indentation.
Message-ID: <20140217212124.GA2236@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been this way for years, and every time I stumble across it I lose my lunch.
After coming across it for the nth time in the Coverity results, I had to overcome
the bystander effect and do something about it.

This ignores the 79 column limit in favor of making it look like C instead of gibberish.

The correct thing to do here would be to lose some of the indentation by breaking this
function up into several smaller ones.  I might do that at some point if I have
the stomach to look at this again.

(Also some of those overlong ternary operations would likely be more readable as regular if's)

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 2b7882b508db..9a3c68cf6026 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -324,23 +324,17 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 			switch (flag) {
 			case M_INSERT:	/* insert item into L[0] */
 
-				if (item_pos == tb->lnum[0] - 1
-				    && tb->lbytes != -1) {
+				if (item_pos == tb->lnum[0] - 1 && tb->lbytes != -1) {
 					/* part of new item falls into L[0] */
 					int new_item_len;
 					int version;
 
-					ret_val =
-					    leaf_shift_left(tb, tb->lnum[0] - 1,
-							    -1);
+					ret_val = leaf_shift_left(tb, tb->lnum[0] - 1, -1);
 
 					/* Calculate item length to insert to S[0] */
-					new_item_len =
-					    ih_item_len(ih) - tb->lbytes;
+					new_item_len = ih_item_len(ih) - tb->lbytes;
 					/* Calculate and check item length to insert to L[0] */
-					put_ih_item_len(ih,
-							ih_item_len(ih) -
-							new_item_len);
+					put_ih_item_len(ih, ih_item_len(ih) - new_item_len);
 
 					RFALSE(ih_item_len(ih) <= 0,
 					       "PAP-12080: there is nothing to insert into L[0]: ih_item_len=%d",
@@ -349,30 +343,18 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 					/* Insert new item into L[0] */
 					buffer_info_init_left(tb, &bi);
 					leaf_insert_into_buf(&bi,
-							     n + item_pos -
-							     ret_val, ih, body,
-							     zeros_num >
-							     ih_item_len(ih) ?
-							     ih_item_len(ih) :
-							     zeros_num);
+							n + item_pos - ret_val, ih, body,
+							zeros_num > ih_item_len(ih) ? ih_item_len(ih) : zeros_num);
 
 					version = ih_version(ih);
 
 					/* Calculate key component, item length and body to insert into S[0] */
-					set_le_ih_k_offset(ih,
-							   le_ih_k_offset(ih) +
-							   (tb->
-							    lbytes <<
-							    (is_indirect_le_ih
-							     (ih) ? tb->tb_sb->
-							     s_blocksize_bits -
-							     UNFM_P_SHIFT :
-							     0)));
+					set_le_ih_k_offset(ih, le_ih_k_offset(ih) +
+							(tb-> lbytes << (is_indirect_le_ih(ih) ? tb->tb_sb-> s_blocksize_bits - UNFM_P_SHIFT : 0)));
 
 					put_ih_item_len(ih, new_item_len);
 					if (tb->lbytes > zeros_num) {
-						body +=
-						    (tb->lbytes - zeros_num);
+						body += (tb->lbytes - zeros_num);
 						zeros_num = 0;
 					} else
 						zeros_num -= tb->lbytes;
@@ -383,15 +365,10 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 				} else {
 					/* new item in whole falls into L[0] */
 					/* Shift lnum[0]-1 items to L[0] */
-					ret_val =
-					    leaf_shift_left(tb, tb->lnum[0] - 1,
-							    tb->lbytes);
+					ret_val = leaf_shift_left(tb, tb->lnum[0] - 1, tb->lbytes);
 					/* Insert new item into L[0] */
 					buffer_info_init_left(tb, &bi);
-					leaf_insert_into_buf(&bi,
-							     n + item_pos -
-							     ret_val, ih, body,
-							     zeros_num);
+					leaf_insert_into_buf(&bi, n + item_pos - ret_val, ih, body, zeros_num);
 					tb->insert_size[0] = 0;
 					zeros_num = 0;
 				}
@@ -399,264 +376,117 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 			case M_PASTE:	/* append item in L[0] */
 
-				if (item_pos == tb->lnum[0] - 1
-				    && tb->lbytes != -1) {
+				if (item_pos == tb->lnum[0] - 1 && tb->lbytes != -1) {
 					/* we must shift the part of the appended item */
-					if (is_direntry_le_ih
-					    (B_N_PITEM_HEAD(tbS0, item_pos))) {
+					if (is_direntry_le_ih(B_N_PITEM_HEAD(tbS0, item_pos))) {
 
 						RFALSE(zeros_num,
 						       "PAP-12090: invalid parameter in case of a directory");
 						/* directory item */
 						if (tb->lbytes > pos_in_item) {
 							/* new directory entry falls into L[0] */
-							struct item_head
-							    *pasted;
-							int l_pos_in_item =
-							    pos_in_item;
+							struct item_head *pasted;
+							int l_pos_in_item = pos_in_item;
 
 							/* Shift lnum[0] - 1 items in whole. Shift lbytes - 1 entries from given directory item */
-							ret_val =
-							    leaf_shift_left(tb,
-									    tb->
-									    lnum
-									    [0],
-									    tb->
-									    lbytes
-									    -
-									    1);
-							if (ret_val
-							    && !item_pos) {
-								pasted =
-								    B_N_PITEM_HEAD
-								    (tb->L[0],
-								     B_NR_ITEMS
-								     (tb->
-								      L[0]) -
-								     1);
-								l_pos_in_item +=
-								    I_ENTRY_COUNT
-								    (pasted) -
-								    (tb->
-								     lbytes -
-								     1);
+							ret_val = leaf_shift_left(tb, tb->lnum[0], tb->lbytes-1);
+							if (ret_val && !item_pos) {
+								pasted = B_N_PITEM_HEAD(tb->L[0], B_NR_ITEMS(tb->L[0]) - 1);
+								l_pos_in_item += I_ENTRY_COUNT(pasted) - (tb->lbytes -1);
 							}
 
 							/* Append given directory entry to directory item */
 							buffer_info_init_left(tb, &bi);
-							leaf_paste_in_buffer
-							    (&bi,
-							     n + item_pos -
-							     ret_val,
-							     l_pos_in_item,
-							     tb->insert_size[0],
-							     body, zeros_num);
+							leaf_paste_in_buffer(&bi, n + item_pos - ret_val, l_pos_in_item, tb->insert_size[0], body, zeros_num);
 
 							/* previous string prepared space for pasting new entry, following string pastes this entry */
 
 							/* when we have merge directory item, pos_in_item has been changed too */
 
 							/* paste new directory entry. 1 is entry number */
-							leaf_paste_entries(&bi,
-									   n +
-									   item_pos
-									   -
-									   ret_val,
-									   l_pos_in_item,
-									   1,
-									   (struct
-									    reiserfs_de_head
-									    *)
-									   body,
-									   body
-									   +
-									   DEH_SIZE,
-									   tb->
-									   insert_size
-									   [0]
-							    );
+							leaf_paste_entries(&bi, n + item_pos - ret_val, l_pos_in_item,
+									   1, (struct reiserfs_de_head *) body,
+									   body + DEH_SIZE, tb->insert_size[0]);
 							tb->insert_size[0] = 0;
 						} else {
 							/* new directory item doesn't fall into L[0] */
 							/* Shift lnum[0]-1 items in whole. Shift lbytes directory entries from directory item number lnum[0] */
-							leaf_shift_left(tb,
-									tb->
-									lnum[0],
-									tb->
-									lbytes);
+							leaf_shift_left(tb, tb->lnum[0], tb->lbytes);
 						}
 						/* Calculate new position to append in item body */
 						pos_in_item -= tb->lbytes;
 					} else {
 						/* regular object */
-						RFALSE(tb->lbytes <= 0,
-						       "PAP-12095: there is nothing to shift to L[0]. lbytes=%d",
-						       tb->lbytes);
-						RFALSE(pos_in_item !=
-						       ih_item_len
-						       (B_N_PITEM_HEAD
-							(tbS0, item_pos)),
+						RFALSE(tb->lbytes <= 0, "PAP-12095: there is nothing to shift to L[0]. lbytes=%d", tb->lbytes);
+						RFALSE(pos_in_item != ih_item_len(B_N_PITEM_HEAD(tbS0, item_pos)),
 						       "PAP-12100: incorrect position to paste: item_len=%d, pos_in_item=%d",
-						       ih_item_len
-						       (B_N_PITEM_HEAD
-							(tbS0, item_pos)),
-						       pos_in_item);
+						       ih_item_len(B_N_PITEM_HEAD(tbS0, item_pos)),pos_in_item);
 
 						if (tb->lbytes >= pos_in_item) {
 							/* appended item will be in L[0] in whole */
 							int l_n;
 
 							/* this bytes number must be appended to the last item of L[h] */
-							l_n =
-							    tb->lbytes -
-							    pos_in_item;
+							l_n = tb->lbytes - pos_in_item;
 
 							/* Calculate new insert_size[0] */
-							tb->insert_size[0] -=
-							    l_n;
+							tb->insert_size[0] -= l_n;
 
-							RFALSE(tb->
-							       insert_size[0] <=
-							       0,
+							RFALSE(tb->insert_size[0] <= 0,
 							       "PAP-12105: there is nothing to paste into L[0]. insert_size=%d",
-							       tb->
-							       insert_size[0]);
-							ret_val =
-							    leaf_shift_left(tb,
-									    tb->
-									    lnum
-									    [0],
-									    ih_item_len
-									    (B_N_PITEM_HEAD
-									     (tbS0,
-									      item_pos)));
+							       tb->insert_size[0]);
+							ret_val = leaf_shift_left(tb, tb->lnum[0], ih_item_len
+									    (B_N_PITEM_HEAD(tbS0, item_pos)));
 							/* Append to body of item in L[0] */
 							buffer_info_init_left(tb, &bi);
 							leaf_paste_in_buffer
-							    (&bi,
-							     n + item_pos -
-							     ret_val,
-							     ih_item_len
-							     (B_N_PITEM_HEAD
-							      (tb->L[0],
-							       n + item_pos -
-							       ret_val)), l_n,
-							     body,
-							     zeros_num >
-							     l_n ? l_n :
-							     zeros_num);
+							    (&bi, n + item_pos - ret_val, ih_item_len
+							     (B_N_PITEM_HEAD(tb->L[0], n + item_pos - ret_val)),
+							     l_n, body,
+							     zeros_num > l_n ? l_n : zeros_num);
 							/* 0-th item in S0 can be only of DIRECT type when l_n != 0 */
 							{
 								int version;
-								int temp_l =
-								    l_n;
-
-								RFALSE
-								    (ih_item_len
-								     (B_N_PITEM_HEAD
-								      (tbS0,
-								       0)),
+								int temp_l = l_n;
+
+								RFALSE(ih_item_len(B_N_PITEM_HEAD(tbS0, 0)),
 								     "PAP-12106: item length must be 0");
-								RFALSE
-								    (comp_short_le_keys
-								     (B_N_PKEY
-								      (tbS0, 0),
-								      B_N_PKEY
-								      (tb->L[0],
-								       n +
-								       item_pos
-								       -
-								       ret_val)),
+								RFALSE(comp_short_le_keys(B_N_PKEY(tbS0, 0), B_N_PKEY
+								      (tb->L[0], n + item_pos - ret_val)),
 								     "PAP-12107: items must be of the same file");
 								if (is_indirect_le_ih(B_N_PITEM_HEAD(tb->L[0], n + item_pos - ret_val))) {
-									temp_l =
-									    l_n
-									    <<
-									    (tb->
-									     tb_sb->
-									     s_blocksize_bits
-									     -
-									     UNFM_P_SHIFT);
+									temp_l = l_n << (tb->tb_sb-> s_blocksize_bits - UNFM_P_SHIFT);
 								}
 								/* update key of first item in S0 */
-								version =
-								    ih_version
-								    (B_N_PITEM_HEAD
-								     (tbS0, 0));
-								set_le_key_k_offset
-								    (version,
-								     B_N_PKEY
-								     (tbS0, 0),
-								     le_key_k_offset
-								     (version,
-								      B_N_PKEY
-								      (tbS0,
-								       0)) +
-								     temp_l);
+								version = ih_version(B_N_PITEM_HEAD(tbS0, 0));
+								set_le_key_k_offset(version, B_N_PKEY(tbS0, 0),
+								     le_key_k_offset(version,B_N_PKEY(tbS0, 0)) + temp_l);
 								/* update left delimiting key */
-								set_le_key_k_offset
-								    (version,
-								     B_N_PDELIM_KEY
-								     (tb->
-								      CFL[0],
-								      tb->
-								      lkey[0]),
-								     le_key_k_offset
-								     (version,
-								      B_N_PDELIM_KEY
-								      (tb->
-								       CFL[0],
-								       tb->
-								       lkey[0]))
-								     + temp_l);
+								set_le_key_k_offset(version, B_N_PDELIM_KEY(tb->CFL[0], tb->lkey[0]),
+								     le_key_k_offset(version, B_N_PDELIM_KEY(tb->CFL[0], tb->lkey[0])) + temp_l);
 							}
 
 							/* Calculate new body, position in item and insert_size[0] */
 							if (l_n > zeros_num) {
-								body +=
-								    (l_n -
-								     zeros_num);
+								body += (l_n - zeros_num);
 								zeros_num = 0;
 							} else
-								zeros_num -=
-								    l_n;
+								zeros_num -= l_n;
 							pos_in_item = 0;
 
-							RFALSE
-							    (comp_short_le_keys
-							     (B_N_PKEY(tbS0, 0),
-							      B_N_PKEY(tb->L[0],
-								       B_NR_ITEMS
-								       (tb->
-									L[0]) -
-								       1))
-							     ||
-							     !op_is_left_mergeable
-							     (B_N_PKEY(tbS0, 0),
-							      tbS0->b_size)
-							     ||
-							     !op_is_left_mergeable
-							     (B_N_PDELIM_KEY
-							      (tb->CFL[0],
-							       tb->lkey[0]),
-							      tbS0->b_size),
+							RFALSE(comp_short_le_keys(B_N_PKEY(tbS0, 0), B_N_PKEY(tb->L[0], B_NR_ITEMS(tb->L[0]) - 1))
+							     || !op_is_left_mergeable(B_N_PKEY(tbS0, 0), tbS0->b_size)
+							     || !op_is_left_mergeable(B_N_PDELIM_KEY(tb->CFL[0], tb->lkey[0]), tbS0->b_size),
 							     "PAP-12120: item must be merge-able with left neighboring item");
 						} else {	/* only part of the appended item will be in L[0] */
 
 							/* Calculate position in item for append in S[0] */
-							pos_in_item -=
-							    tb->lbytes;
+							pos_in_item -= tb->lbytes;
 
-							RFALSE(pos_in_item <= 0,
-							       "PAP-12125: no place for paste. pos_in_item=%d",
-							       pos_in_item);
+							RFALSE(pos_in_item <= 0, "PAP-12125: no place for paste. pos_in_item=%d", pos_in_item);
 
 							/* Shift lnum[0] - 1 items in whole. Shift lbytes - 1 byte from item number lnum[0] */
-							leaf_shift_left(tb,
-									tb->
-									lnum[0],
-									tb->
-									lbytes);
+							leaf_shift_left(tb, tb->lnum[0], tb->lbytes);
 						}
 					}
 				} else {	/* appended item will be in L[0] in whole */
@@ -665,52 +495,30 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 					if (!item_pos && op_is_left_mergeable(B_N_PKEY(tbS0, 0), tbS0->b_size)) {	/* if we paste into first item of S[0] and it is left mergable */
 						/* then increment pos_in_item by the size of the last item in L[0] */
-						pasted =
-						    B_N_PITEM_HEAD(tb->L[0],
-								   n - 1);
+						pasted = B_N_PITEM_HEAD(tb->L[0], n - 1);
 						if (is_direntry_le_ih(pasted))
-							pos_in_item +=
-							    ih_entry_count
-							    (pasted);
+							pos_in_item += ih_entry_count(pasted);
 						else
-							pos_in_item +=
-							    ih_item_len(pasted);
+							pos_in_item += ih_item_len(pasted);
 					}
 
 					/* Shift lnum[0] - 1 items in whole. Shift lbytes - 1 byte from item number lnum[0] */
-					ret_val =
-					    leaf_shift_left(tb, tb->lnum[0],
-							    tb->lbytes);
+					ret_val = leaf_shift_left(tb, tb->lnum[0], tb->lbytes);
 					/* Append to body of item in L[0] */
 					buffer_info_init_left(tb, &bi);
-					leaf_paste_in_buffer(&bi,
-							     n + item_pos -
-							     ret_val,
+					leaf_paste_in_buffer(&bi, n + item_pos - ret_val,
 							     pos_in_item,
 							     tb->insert_size[0],
 							     body, zeros_num);
 
 					/* if appended item is directory, paste entry */
-					pasted =
-					    B_N_PITEM_HEAD(tb->L[0],
-							   n + item_pos -
-							   ret_val);
+					pasted = B_N_PITEM_HEAD(tb->L[0], n + item_pos - ret_val);
 					if (is_direntry_le_ih(pasted))
-						leaf_paste_entries(&bi,
-								   n +
-								   item_pos -
-								   ret_val,
-								   pos_in_item,
-								   1,
-								   (struct
-								    reiserfs_de_head
-								    *)body,
-								   body +
-								   DEH_SIZE,
-								   tb->
-								   insert_size
-								   [0]
-						    );
+						leaf_paste_entries(&bi, n + item_pos - ret_val,
+								   pos_in_item, 1,
+								   (struct reiserfs_de_head *) body,
+								   body + DEH_SIZE,
+								   tb->insert_size[0]);
 					/* if appended item is indirect item, put unformatted node into un list */
 					if (is_indirect_le_ih(pasted))
 						set_ih_free_space(pasted, 0);
@@ -722,13 +530,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 				reiserfs_panic(tb->tb_sb, "PAP-12130",
 					       "lnum > 0: unexpected mode: "
 					       " %s(%d)",
-					       (flag ==
-						M_DELETE) ? "DELETE" : ((flag ==
-									 M_CUT)
-									? "CUT"
-									:
-									"UNKNOWN"),
-					       flag);
+					       (flag == M_DELETE) ? "DELETE" : ((flag == M_CUT) ? "CUT" : "UNKNOWN"), flag);
 			}
 		} else {
 			/* new item doesn't fall into L[0] */
@@ -748,14 +550,12 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 		case M_INSERT:	/* insert item */
 			if (n - tb->rnum[0] < item_pos) {	/* new item or its part falls to R[0] */
 				if (item_pos == n - tb->rnum[0] + 1 && tb->rbytes != -1) {	/* part of new item falls into R[0] */
-					loff_t old_key_comp, old_len,
-					    r_zeros_number;
+					loff_t old_key_comp, old_len, r_zeros_number;
 					const char *r_body;
 					int version;
 					loff_t offset;
 
-					leaf_shift_right(tb, tb->rnum[0] - 1,
-							 -1);
+					leaf_shift_right(tb, tb->rnum[0] - 1, -1);
 
 					version = ih_version(ih);
 					/* Remember key component and item length */
@@ -763,29 +563,17 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 					old_len = ih_item_len(ih);
 
 					/* Calculate key component and item length to insert into R[0] */
-					offset =
-					    le_ih_k_offset(ih) +
-					    ((old_len -
-					      tb->
-					      rbytes) << (is_indirect_le_ih(ih)
-							  ? tb->tb_sb->
-							  s_blocksize_bits -
-							  UNFM_P_SHIFT : 0));
+					offset = le_ih_k_offset(ih) + ((old_len - tb->rbytes) << (is_indirect_le_ih(ih) ? tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT : 0));
 					set_le_ih_k_offset(ih, offset);
 					put_ih_item_len(ih, tb->rbytes);
 					/* Insert part of the item into R[0] */
 					buffer_info_init_right(tb, &bi);
 					if ((old_len - tb->rbytes) > zeros_num) {
 						r_zeros_number = 0;
-						r_body =
-						    body + (old_len -
-							    tb->rbytes) -
-						    zeros_num;
+						r_body = body + (old_len - tb->rbytes) - zeros_num;
 					} else {
 						r_body = body;
-						r_zeros_number =
-						    zeros_num - (old_len -
-								 tb->rbytes);
+						r_zeros_number = zeros_num - (old_len - tb->rbytes);
 						zeros_num -= r_zeros_number;
 					}
 
@@ -798,25 +586,18 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 					/* Calculate key component and item length to insert into S[0] */
 					set_le_ih_k_offset(ih, old_key_comp);
-					put_ih_item_len(ih,
-							old_len - tb->rbytes);
+					put_ih_item_len(ih, old_len - tb->rbytes);
 
 					tb->insert_size[0] -= tb->rbytes;
 
 				} else {	/* whole new item falls into R[0] */
 
 					/* Shift rnum[0]-1 items to R[0] */
-					ret_val =
-					    leaf_shift_right(tb,
-							     tb->rnum[0] - 1,
-							     tb->rbytes);
+					ret_val = leaf_shift_right(tb, tb->rnum[0] - 1, tb->rbytes);
 					/* Insert new item into R[0] */
 					buffer_info_init_right(tb, &bi);
-					leaf_insert_into_buf(&bi,
-							     item_pos - n +
-							     tb->rnum[0] - 1,
-							     ih, body,
-							     zeros_num);
+					leaf_insert_into_buf(&bi, item_pos - n + tb->rnum[0] - 1,
+							     ih, body, zeros_num);
 
 					if (item_pos - n + tb->rnum[0] - 1 == 0) {
 						replace_key(tb, tb->CFR[0],
@@ -841,200 +622,97 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 						RFALSE(zeros_num,
 						       "PAP-12145: invalid parameter in case of a directory");
-						entry_count =
-						    I_ENTRY_COUNT(B_N_PITEM_HEAD
-								  (tbS0,
-								   item_pos));
+						entry_count = I_ENTRY_COUNT(B_N_PITEM_HEAD
+								  (tbS0, item_pos));
 						if (entry_count - tb->rbytes <
 						    pos_in_item)
 							/* new directory entry falls into R[0] */
 						{
 							int paste_entry_position;
 
-							RFALSE(tb->rbytes - 1 >=
-							       entry_count
-							       || !tb->
-							       insert_size[0],
+							RFALSE(tb->rbytes - 1 >= entry_count || !tb-> insert_size[0],
 							       "PAP-12150: no enough of entries to shift to R[0]: rbytes=%d, entry_count=%d",
-							       tb->rbytes,
-							       entry_count);
+							       tb->rbytes, entry_count);
 							/* Shift rnum[0]-1 items in whole. Shift rbytes-1 directory entries from directory item number rnum[0] */
-							leaf_shift_right(tb,
-									 tb->
-									 rnum
-									 [0],
-									 tb->
-									 rbytes
-									 - 1);
+							leaf_shift_right(tb, tb->rnum[0], tb->rbytes - 1);
 							/* Paste given directory entry to directory item */
-							paste_entry_position =
-							    pos_in_item -
-							    entry_count +
-							    tb->rbytes - 1;
+							paste_entry_position = pos_in_item - entry_count + tb->rbytes - 1;
 							buffer_info_init_right(tb, &bi);
-							leaf_paste_in_buffer
-							    (&bi, 0,
-							     paste_entry_position,
-							     tb->insert_size[0],
-							     body, zeros_num);
+							leaf_paste_in_buffer(&bi, 0, paste_entry_position, tb->insert_size[0], body, zeros_num);
 							/* paste entry */
-							leaf_paste_entries(&bi,
-									   0,
-									   paste_entry_position,
-									   1,
-									   (struct
-									    reiserfs_de_head
-									    *)
-									   body,
-									   body
-									   +
-									   DEH_SIZE,
-									   tb->
-									   insert_size
-									   [0]
-							    );
-
-							if (paste_entry_position
-							    == 0) {
+							leaf_paste_entries(&bi, 0, paste_entry_position, 1,
+									   (struct reiserfs_de_head *) body,
+									   body + DEH_SIZE, tb->insert_size[0]);
+
+							if (paste_entry_position == 0) {
 								/* change delimiting keys */
-								replace_key(tb,
-									    tb->
-									    CFR
-									    [0],
-									    tb->
-									    rkey
-									    [0],
-									    tb->
-									    R
-									    [0],
-									    0);
+								replace_key(tb, tb->CFR[0], tb->rkey[0], tb->R[0],0);
 							}
 
 							tb->insert_size[0] = 0;
 							pos_in_item++;
 						} else {	/* new directory entry doesn't fall into R[0] */
 
-							leaf_shift_right(tb,
-									 tb->
-									 rnum
-									 [0],
-									 tb->
-									 rbytes);
+							leaf_shift_right(tb, tb->rnum[0], tb->rbytes);
 						}
 					} else {	/* regular object */
 
-						int n_shift, n_rem,
-						    r_zeros_number;
+						int n_shift, n_rem, r_zeros_number;
 						const char *r_body;
 
 						/* Calculate number of bytes which must be shifted from appended item */
-						if ((n_shift =
-						     tb->rbytes -
-						     tb->insert_size[0]) < 0)
+						if ((n_shift = tb->rbytes - tb->insert_size[0]) < 0)
 							n_shift = 0;
 
-						RFALSE(pos_in_item !=
-						       ih_item_len
-						       (B_N_PITEM_HEAD
-							(tbS0, item_pos)),
+						RFALSE(pos_in_item != ih_item_len
+						       (B_N_PITEM_HEAD(tbS0, item_pos)),
 						       "PAP-12155: invalid position to paste. ih_item_len=%d, pos_in_item=%d",
-						       pos_in_item,
-						       ih_item_len
-						       (B_N_PITEM_HEAD
-							(tbS0, item_pos)));
-
-						leaf_shift_right(tb,
-								 tb->rnum[0],
-								 n_shift);
+						       pos_in_item, ih_item_len
+						       (B_N_PITEM_HEAD(tbS0, item_pos)));
+
+						leaf_shift_right(tb, tb->rnum[0], n_shift);
 						/* Calculate number of bytes which must remain in body after appending to R[0] */
-						if ((n_rem =
-						     tb->insert_size[0] -
-						     tb->rbytes) < 0)
+						if ((n_rem = tb->insert_size[0] - tb->rbytes) < 0)
 							n_rem = 0;
 
 						{
 							int version;
-							unsigned long temp_rem =
-							    n_rem;
-
-							version =
-							    ih_version
-							    (B_N_PITEM_HEAD
-							     (tb->R[0], 0));
-							if (is_indirect_le_key
-							    (version,
-							     B_N_PKEY(tb->R[0],
-								      0))) {
-								temp_rem =
-								    n_rem <<
-								    (tb->tb_sb->
-								     s_blocksize_bits
-								     -
-								     UNFM_P_SHIFT);
+							unsigned long temp_rem = n_rem;
+
+							version = ih_version(B_N_PITEM_HEAD(tb->R[0], 0));
+							if (is_indirect_le_key(version, B_N_PKEY(tb->R[0], 0))) {
+								temp_rem = n_rem << (tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT);
 							}
-							set_le_key_k_offset
-							    (version,
-							     B_N_PKEY(tb->R[0],
-								      0),
-							     le_key_k_offset
-							     (version,
-							      B_N_PKEY(tb->R[0],
-								       0)) +
-							     temp_rem);
-							set_le_key_k_offset
-							    (version,
-							     B_N_PDELIM_KEY(tb->
-									    CFR
-									    [0],
-									    tb->
-									    rkey
-									    [0]),
-							     le_key_k_offset
-							     (version,
-							      B_N_PDELIM_KEY
-							      (tb->CFR[0],
-							       tb->rkey[0])) +
-							     temp_rem);
+							set_le_key_k_offset(version, B_N_PKEY(tb->R[0], 0),
+							     le_key_k_offset(version, B_N_PKEY(tb->R[0], 0)) + temp_rem);
+							set_le_key_k_offset(version, B_N_PDELIM_KEY(tb->CFR[0], tb->rkey[0]),
+							     le_key_k_offset(version, B_N_PDELIM_KEY(tb->CFR[0], tb->rkey[0])) + temp_rem);
 						}
 /*		  k_offset (B_N_PKEY(tb->R[0],0)) += n_rem;
 		  k_offset (B_N_PDELIM_KEY(tb->CFR[0],tb->rkey[0])) += n_rem;*/
-						do_balance_mark_internal_dirty
-						    (tb, tb->CFR[0], 0);
+						do_balance_mark_internal_dirty(tb, tb->CFR[0], 0);
 
 						/* Append part of body into R[0] */
 						buffer_info_init_right(tb, &bi);
 						if (n_rem > zeros_num) {
 							r_zeros_number = 0;
-							r_body =
-							    body + n_rem -
-							    zeros_num;
+							r_body = body + n_rem - zeros_num;
 						} else {
 							r_body = body;
-							r_zeros_number =
-							    zeros_num - n_rem;
-							zeros_num -=
-							    r_zeros_number;
+							r_zeros_number = zeros_num - n_rem;
+							zeros_num -= r_zeros_number;
 						}
 
-						leaf_paste_in_buffer(&bi, 0,
-								     n_shift,
-								     tb->
-								     insert_size
-								     [0] -
-								     n_rem,
-								     r_body,
-								     r_zeros_number);
-
-						if (is_indirect_le_ih
-						    (B_N_PITEM_HEAD
-						     (tb->R[0], 0))) {
+						leaf_paste_in_buffer(&bi, 0, n_shift,
+								     tb->insert_size[0] - n_rem,
+								     r_body, r_zeros_number);
+
+						if (is_indirect_le_ih(B_N_PITEM_HEAD(tb->R[0], 0))) {
 #if 0
 							RFALSE(n_rem,
 							       "PAP-12160: paste more than one unformatted node pointer");
 #endif
-							set_ih_free_space
-							    (B_N_PITEM_HEAD
-							     (tb->R[0], 0), 0);
+							set_ih_free_space(B_N_PITEM_HEAD(tb->R[0], 0), 0);
 						}
 						tb->insert_size[0] = n_rem;
 						if (!n_rem)
@@ -1044,58 +722,28 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 					struct item_head *pasted;
 
-					ret_val =
-					    leaf_shift_right(tb, tb->rnum[0],
-							     tb->rbytes);
+					ret_val = leaf_shift_right(tb, tb->rnum[0], tb->rbytes);
 					/* append item in R[0] */
 					if (pos_in_item >= 0) {
 						buffer_info_init_right(tb, &bi);
-						leaf_paste_in_buffer(&bi,
-								     item_pos -
-								     n +
-								     tb->
-								     rnum[0],
-								     pos_in_item,
-								     tb->
-								     insert_size
-								     [0], body,
-								     zeros_num);
+						leaf_paste_in_buffer(&bi, item_pos - n + tb->rnum[0], pos_in_item,
+								     tb->insert_size[0], body, zeros_num);
 					}
 
 					/* paste new entry, if item is directory item */
-					pasted =
-					    B_N_PITEM_HEAD(tb->R[0],
-							   item_pos - n +
-							   tb->rnum[0]);
-					if (is_direntry_le_ih(pasted)
-					    && pos_in_item >= 0) {
-						leaf_paste_entries(&bi,
-								   item_pos -
-								   n +
-								   tb->rnum[0],
-								   pos_in_item,
-								   1,
-								   (struct
-								    reiserfs_de_head
-								    *)body,
-								   body +
-								   DEH_SIZE,
-								   tb->
-								   insert_size
-								   [0]
-						    );
+					pasted = B_N_PITEM_HEAD(tb->R[0], item_pos - n + tb->rnum[0]);
+					if (is_direntry_le_ih(pasted) && pos_in_item >= 0) {
+						leaf_paste_entries(&bi, item_pos - n + tb->rnum[0],
+								   pos_in_item, 1,
+								   (struct reiserfs_de_head *) body,
+								   body + DEH_SIZE, tb->insert_size[0]);
 						if (!pos_in_item) {
 
-							RFALSE(item_pos - n +
-							       tb->rnum[0],
+							RFALSE(item_pos - n + tb->rnum[0],
 							       "PAP-12165: directory item must be first item of node when pasting is in 0th position");
 
 							/* update delimiting keys */
-							replace_key(tb,
-								    tb->CFR[0],
-								    tb->rkey[0],
-								    tb->R[0],
-								    0);
+							replace_key(tb, tb->CFR[0], tb->rkey[0], tb->R[0], 0);
 						}
 					}
 
@@ -1111,22 +759,16 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 		default:	/* cases d and t */
 			reiserfs_panic(tb->tb_sb, "PAP-12175",
 				       "rnum > 0: unexpected mode: %s(%d)",
-				       (flag ==
-					M_DELETE) ? "DELETE" : ((flag ==
-								 M_CUT) ? "CUT"
-								: "UNKNOWN"),
-				       flag);
+				       (flag == M_DELETE) ? "DELETE" : ((flag == M_CUT) ? "CUT" : "UNKNOWN"), flag);
 		}
 
 	}
 
 	/* tb->rnum[0] > 0 */
 	RFALSE(tb->blknum[0] > 3,
-	       "PAP-12180: blknum can not be %d. It must be <= 3",
-	       tb->blknum[0]);
+	       "PAP-12180: blknum can not be %d. It must be <= 3", tb->blknum[0]);
 	RFALSE(tb->blknum[0] < 0,
-	       "PAP-12185: blknum can not be %d. It must be >= 0",
-	       tb->blknum[0]);
+	       "PAP-12185: blknum can not be %d. It must be >= 0", tb->blknum[0]);
 
 	/* if while adding to a node we discover that it is possible to split
 	   it in two, and merge the left part into the left neighbor and the
@@ -1177,8 +819,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 			if (n - snum[i] < item_pos) {	/* new item or it's part falls to first new node S_new[i] */
 				if (item_pos == n - snum[i] + 1 && sbytes[i] != -1) {	/* part of new item falls into S_new[i] */
-					int old_key_comp, old_len,
-					    r_zeros_number;
+					int old_key_comp, old_len, r_zeros_number;
 					const char *r_body;
 					int version;
 
@@ -1192,15 +833,8 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 					old_len = ih_item_len(ih);
 
 					/* Calculate key component and item length to insert into S_new[i] */
-					set_le_ih_k_offset(ih,
-							   le_ih_k_offset(ih) +
-							   ((old_len -
-							     sbytes[i]) <<
-							    (is_indirect_le_ih
-							     (ih) ? tb->tb_sb->
-							     s_blocksize_bits -
-							     UNFM_P_SHIFT :
-							     0)));
+					set_le_ih_k_offset(ih, le_ih_k_offset(ih) +
+							   ((old_len - sbytes[i]) << (is_indirect_le_ih(ih) ? tb->tb_sb-> s_blocksize_bits - UNFM_P_SHIFT : 0)));
 
 					put_ih_item_len(ih, sbytes[i]);
 
@@ -1209,39 +843,29 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 					if ((old_len - sbytes[i]) > zeros_num) {
 						r_zeros_number = 0;
-						r_body =
-						    body + (old_len -
-							    sbytes[i]) -
-						    zeros_num;
+						r_body = body + (old_len - sbytes[i]) - zeros_num;
 					} else {
 						r_body = body;
-						r_zeros_number =
-						    zeros_num - (old_len -
-								 sbytes[i]);
+						r_zeros_number = zeros_num - (old_len - sbytes[i]);
 						zeros_num -= r_zeros_number;
 					}
 
-					leaf_insert_into_buf(&bi, 0, ih, r_body,
-							     r_zeros_number);
+					leaf_insert_into_buf(&bi, 0, ih, r_body, r_zeros_number);
 
 					/* Calculate key component and item length to insert into S[i] */
 					set_le_ih_k_offset(ih, old_key_comp);
-					put_ih_item_len(ih,
-							old_len - sbytes[i]);
+					put_ih_item_len(ih, old_len - sbytes[i]);
 					tb->insert_size[0] -= sbytes[i];
 				} else {	/* whole new item falls into S_new[i] */
 
 					/* Shift snum[0] - 1 items to S_new[i] (sbytes[i] of split item) */
 					leaf_move_items(LEAF_FROM_S_TO_SNEW, tb,
-							snum[i] - 1, sbytes[i],
-							S_new[i]);
+							snum[i] - 1, sbytes[i], S_new[i]);
 
 					/* Insert new item into S_new[i] */
 					buffer_info_init_bh(tb, &bi, S_new[i]);
-					leaf_insert_into_buf(&bi,
-							     item_pos - n +
-							     snum[i] - 1, ih,
-							     body, zeros_num);
+					leaf_insert_into_buf(&bi, item_pos - n + snum[i] - 1,
+							     ih, body, zeros_num);
 
 					zeros_num = tb->insert_size[0] = 0;
 				}
@@ -1268,150 +892,73 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 						int entry_count;
 
-						entry_count =
-						    ih_entry_count(aux_ih);
+						entry_count = ih_entry_count(aux_ih);
 
-						if (entry_count - sbytes[i] <
-						    pos_in_item
-						    && pos_in_item <=
-						    entry_count) {
+						if (entry_count - sbytes[i] < pos_in_item && pos_in_item <= entry_count) {
 							/* new directory entry falls into S_new[i] */
 
-							RFALSE(!tb->
-							       insert_size[0],
-							       "PAP-12215: insert_size is already 0");
-							RFALSE(sbytes[i] - 1 >=
-							       entry_count,
+							RFALSE(!tb->insert_size[0], "PAP-12215: insert_size is already 0");
+							RFALSE(sbytes[i] - 1 >= entry_count,
 							       "PAP-12220: there are no so much entries (%d), only %d",
-							       sbytes[i] - 1,
-							       entry_count);
+							       sbytes[i] - 1, entry_count);
 
 							/* Shift snum[i]-1 items in whole. Shift sbytes[i] directory entries from directory item number snum[i] */
-							leaf_move_items
-							    (LEAF_FROM_S_TO_SNEW,
-							     tb, snum[i],
-							     sbytes[i] - 1,
-							     S_new[i]);
+							leaf_move_items(LEAF_FROM_S_TO_SNEW, tb, snum[i], sbytes[i] - 1, S_new[i]);
 							/* Paste given directory entry to directory item */
 							buffer_info_init_bh(tb, &bi, S_new[i]);
-							leaf_paste_in_buffer
-							    (&bi, 0,
-							     pos_in_item -
-							     entry_count +
-							     sbytes[i] - 1,
-							     tb->insert_size[0],
-							     body, zeros_num);
+							leaf_paste_in_buffer(&bi, 0, pos_in_item - entry_count + sbytes[i] - 1,
+							     tb->insert_size[0], body, zeros_num);
 							/* paste new directory entry */
-							leaf_paste_entries(&bi,
-									   0,
-									   pos_in_item
-									   -
-									   entry_count
-									   +
-									   sbytes
-									   [i] -
-									   1, 1,
-									   (struct
-									    reiserfs_de_head
-									    *)
-									   body,
-									   body
-									   +
-									   DEH_SIZE,
-									   tb->
-									   insert_size
-									   [0]
-							    );
+							leaf_paste_entries(&bi, 0, pos_in_item - entry_count + sbytes[i] - 1, 1,
+									   (struct reiserfs_de_head *) body,
+									   body + DEH_SIZE, tb->insert_size[0]);
 							tb->insert_size[0] = 0;
 							pos_in_item++;
 						} else {	/* new directory entry doesn't fall into S_new[i] */
-							leaf_move_items
-							    (LEAF_FROM_S_TO_SNEW,
-							     tb, snum[i],
-							     sbytes[i],
-							     S_new[i]);
+							leaf_move_items(LEAF_FROM_S_TO_SNEW,tb, snum[i], sbytes[i], S_new[i]);
 						}
 					} else {	/* regular object */
 
-						int n_shift, n_rem,
-						    r_zeros_number;
+						int n_shift, n_rem, r_zeros_number;
 						const char *r_body;
 
-						RFALSE(pos_in_item !=
-						       ih_item_len
-						       (B_N_PITEM_HEAD
-							(tbS0, item_pos))
-						       || tb->insert_size[0] <=
-						       0,
+						RFALSE(pos_in_item != ih_item_len(B_N_PITEM_HEAD(tbS0, item_pos)) || tb->insert_size[0] <= 0,
 						       "PAP-12225: item too short or insert_size <= 0");
 
 						/* Calculate number of bytes which must be shifted from appended item */
-						n_shift =
-						    sbytes[i] -
-						    tb->insert_size[0];
+						n_shift = sbytes[i] - tb->insert_size[0];
 						if (n_shift < 0)
 							n_shift = 0;
-						leaf_move_items
-						    (LEAF_FROM_S_TO_SNEW, tb,
-						     snum[i], n_shift,
-						     S_new[i]);
+						leaf_move_items(LEAF_FROM_S_TO_SNEW, tb, snum[i], n_shift, S_new[i]);
 
 						/* Calculate number of bytes which must remain in body after append to S_new[i] */
-						n_rem =
-						    tb->insert_size[0] -
-						    sbytes[i];
+						n_rem = tb->insert_size[0] - sbytes[i];
 						if (n_rem < 0)
 							n_rem = 0;
 						/* Append part of body into S_new[0] */
 						buffer_info_init_bh(tb, &bi, S_new[i]);
 						if (n_rem > zeros_num) {
 							r_zeros_number = 0;
-							r_body =
-							    body + n_rem -
-							    zeros_num;
+							r_body = body + n_rem - zeros_num;
 						} else {
 							r_body = body;
-							r_zeros_number =
-							    zeros_num - n_rem;
-							zeros_num -=
-							    r_zeros_number;
+							r_zeros_number = zeros_num - n_rem;
+							zeros_num -= r_zeros_number;
 						}
 
-						leaf_paste_in_buffer(&bi, 0,
-								     n_shift,
-								     tb->
-								     insert_size
-								     [0] -
-								     n_rem,
-								     r_body,
-								     r_zeros_number);
+						leaf_paste_in_buffer(&bi, 0, n_shift,
+								     tb->insert_size[0] - n_rem,
+								     r_body, r_zeros_number);
 						{
 							struct item_head *tmp;
 
-							tmp =
-							    B_N_PITEM_HEAD(S_new
-									   [i],
-									   0);
+							tmp = B_N_PITEM_HEAD(S_new[i], 0);
 							if (is_indirect_le_ih
 							    (tmp)) {
-								set_ih_free_space
-								    (tmp, 0);
-								set_le_ih_k_offset
-								    (tmp,
-								     le_ih_k_offset
-								     (tmp) +
-								     (n_rem <<
-								      (tb->
-								       tb_sb->
-								       s_blocksize_bits
-								       -
-								       UNFM_P_SHIFT)));
+								set_ih_free_space(tmp, 0);
+								set_le_ih_k_offset(tmp, le_ih_k_offset(tmp) + (n_rem << (tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT)));
 							} else {
-								set_le_ih_k_offset
-								    (tmp,
-								     le_ih_k_offset
-								     (tmp) +
-								     n_rem);
+								set_le_ih_k_offset(tmp, le_ih_k_offset(tmp) + n_rem);
 							}
 						}
 
@@ -1426,8 +973,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 					struct item_head *pasted;
 
 #ifdef CONFIG_REISERFS_CHECK
-					struct item_head *ih_check =
-					    B_N_PITEM_HEAD(tbS0, item_pos);
+					struct item_head *ih_check = B_N_PITEM_HEAD(tbS0, item_pos);
 
 					if (!is_direntry_le_ih(ih_check)
 					    && (pos_in_item != ih_item_len(ih_check)
@@ -1439,8 +985,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 							     "to ih_item_len");
 #endif				/* CONFIG_REISERFS_CHECK */
 
-					leaf_mi =
-					    leaf_move_items(LEAF_FROM_S_TO_SNEW,
+					leaf_mi = leaf_move_items(LEAF_FROM_S_TO_SNEW,
 							    tb, snum[i],
 							    sbytes[i],
 							    S_new[i]);
@@ -1452,30 +997,19 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 					/* paste into item */
 					buffer_info_init_bh(tb, &bi, S_new[i]);
 					leaf_paste_in_buffer(&bi,
-							     item_pos - n +
-							     snum[i],
+							     item_pos - n + snum[i],
 							     pos_in_item,
 							     tb->insert_size[0],
 							     body, zeros_num);
 
-					pasted =
-					    B_N_PITEM_HEAD(S_new[i],
-							   item_pos - n +
-							   snum[i]);
+					pasted = B_N_PITEM_HEAD(S_new[i], item_pos - n + snum[i]);
 					if (is_direntry_le_ih(pasted)) {
 						leaf_paste_entries(&bi,
-								   item_pos -
-								   n + snum[i],
-								   pos_in_item,
-								   1,
-								   (struct
-								    reiserfs_de_head
-								    *)body,
-								   body +
-								   DEH_SIZE,
-								   tb->
-								   insert_size
-								   [0]
+								   item_pos - n + snum[i],
+								   pos_in_item, 1,
+								   (struct reiserfs_de_head *)body,
+								   body + DEH_SIZE,
+								   tb->insert_size[0]
 						    );
 					}
 
@@ -1495,11 +1029,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 		default:	/* cases d and t */
 			reiserfs_panic(tb->tb_sb, "PAP-12245",
 				       "blknum > 2: unexpected mode: %s(%d)",
-				       (flag ==
-					M_DELETE) ? "DELETE" : ((flag ==
-								 M_CUT) ? "CUT"
-								: "UNKNOWN"),
-				       flag);
+				       (flag == M_DELETE) ? "DELETE" : ((flag == M_CUT) ? "CUT" : "UNKNOWN"), flag);
 		}
 
 		memcpy(insert_key + i, B_N_PKEY(S_new[i], 0), KEY_SIZE);
@@ -1524,9 +1054,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 			/* If we insert the first key change the delimiting key */
 			if (item_pos == 0) {
 				if (tb->CFL[0])	/* can be 0 in reiserfsck */
-					replace_key(tb, tb->CFL[0], tb->lkey[0],
-						    tbS0, 0);
-
+					replace_key(tb, tb->CFL[0], tb->lkey[0], tbS0, 0);
 			}
 			break;
 
@@ -1536,53 +1064,27 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 				pasted = B_N_PITEM_HEAD(tbS0, item_pos);
 				/* when directory, may be new entry already pasted */
 				if (is_direntry_le_ih(pasted)) {
-					if (pos_in_item >= 0 &&
-					    pos_in_item <=
-					    ih_entry_count(pasted)) {
+					if (pos_in_item >= 0 && pos_in_item <= ih_entry_count(pasted)) {
 
 						RFALSE(!tb->insert_size[0],
 						       "PAP-12260: insert_size is 0 already");
 
 						/* prepare space */
 						buffer_info_init_tbS0(tb, &bi);
-						leaf_paste_in_buffer(&bi,
-								     item_pos,
-								     pos_in_item,
-								     tb->
-								     insert_size
-								     [0], body,
+						leaf_paste_in_buffer(&bi, item_pos, pos_in_item,
+								     tb->insert_size[0], body,
 								     zeros_num);
 
 						/* paste entry */
-						leaf_paste_entries(&bi,
-								   item_pos,
-								   pos_in_item,
-								   1,
-								   (struct
-								    reiserfs_de_head
-								    *)body,
-								   body +
-								   DEH_SIZE,
-								   tb->
-								   insert_size
-								   [0]
-						    );
+						leaf_paste_entries(&bi, item_pos, pos_in_item, 1,
+								   (struct reiserfs_de_head *)body,
+								   body + DEH_SIZE,
+								   tb->insert_size[0]);
 						if (!item_pos && !pos_in_item) {
-							RFALSE(!tb->CFL[0]
-							       || !tb->L[0],
+							RFALSE(!tb->CFL[0] || !tb->L[0],
 							       "PAP-12270: CFL[0]/L[0] must be specified");
-							if (tb->CFL[0]) {
-								replace_key(tb,
-									    tb->
-									    CFL
-									    [0],
-									    tb->
-									    lkey
-									    [0],
-									    tbS0,
-									    0);
-
-							}
+							if (tb->CFL[0])
+								replace_key(tb, tb->CFL[0], tb->lkey[0], tbS0, 0);
 						}
 						tb->insert_size[0] = 0;
 					}
@@ -1593,13 +1095,8 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 						       "PAP-12275: insert size must not be %d",
 						       tb->insert_size[0]);
 						buffer_info_init_tbS0(tb, &bi);
-						leaf_paste_in_buffer(&bi,
-								     item_pos,
-								     pos_in_item,
-								     tb->
-								     insert_size
-								     [0], body,
-								     zeros_num);
+						leaf_paste_in_buffer(&bi, item_pos, pos_in_item,
+								     tb->insert_size[0], body, zeros_num);
 
 						if (is_indirect_le_ih(pasted)) {
 #if 0
@@ -1611,8 +1108,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 							       tb->
 							       insert_size[0]);
 #endif
-							set_ih_free_space
-							    (pasted, 0);
+							set_ih_free_space(pasted, 0);
 						}
 						tb->insert_size[0] = 0;
 					}
@@ -1620,8 +1116,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 					else {
 						if (tb->insert_size[0]) {
 							print_cur_tb("12285");
-							reiserfs_panic(tb->
-								       tb_sb,
+							reiserfs_panic(tb->tb_sb,
 							    "PAP-12285",
 							    "insert_size "
 							    "must be 0 "
