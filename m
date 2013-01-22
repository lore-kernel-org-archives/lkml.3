Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3AVQyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:54:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab3AVQyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:54:47 -0500
Date: Tue, 22 Jan 2013 08:53:18 -0800
From: tip-bot for Daniel J Blueman <daniel@numascale-asia.com>
Message-ID: <tip-c7e5301a1b7c3f47af635a8b1b14480b81426025@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@alien8.de, daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, daniel@numascale-asia.com
In-Reply-To: <1354265060-22956-2-git-send-email-daniel@numascale-asia.com>
References: <1354265060-22956-2-git-send-email-daniel@numascale-asia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] amd64_edac:
  Fix type usage in NB IDs and memory ranges
Git-Commit-ID: c7e5301a1b7c3f47af635a8b1b14480b81426025
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 22 Jan 2013 08:53:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7e5301a1b7c3f47af635a8b1b14480b81426025
Gitweb:     http://git.kernel.org/tip/c7e5301a1b7c3f47af635a8b1b14480b81426025
Author:     Daniel J Blueman <daniel@numascale-asia.com>
AuthorDate: Fri, 30 Nov 2012 16:44:20 +0800
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 10 Jan 2013 16:18:00 +0100

amd64_edac: Fix type usage in NB IDs and memory ranges

Use appropriate types for northbridge IDs and memory ranges. Mark
immutable data const and keep within compilation unit on related
structures.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Link: http://lkml.kernel.org/r/1354265060-22956-2-git-send-email-daniel@numascale-asia.com
[Boris: Drop arg change to node_to_amd_nb]
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/edac/amd64_edac.c | 26 +++++++++++++-------------
 drivers/edac/amd64_edac.h |  6 +++---
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index da76912..2d3f882 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -31,7 +31,7 @@ static struct ecc_settings **ecc_stngs;
  *
  *FIXME: Produce a better mapping/linearisation.
  */
-struct scrubrate {
+static const struct scrubrate {
        u32 scrubval;           /* bit pattern for scrub rate */
        u32 bandwidth;          /* bandwidth consumed (bytes/sec) */
 } scrubrates[] = {
@@ -239,7 +239,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
  * DRAM base/limit associated with node_id
  */
 static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr,
-				   unsigned nid)
+				   u8 nid)
 {
 	u64 addr;
 
@@ -265,7 +265,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 						u64 sys_addr)
 {
 	struct amd64_pvt *pvt;
-	unsigned node_id;
+	u8 node_id;
 	u32 intlv_en, bits;
 
 	/*
@@ -1327,7 +1327,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /* Convert the sys_addr to the normalized DCT address */
-static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
+static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
 				 u64 sys_addr, bool hi_rng,
 				 u32 dct_sel_base_addr)
 {
@@ -1403,7 +1403,7 @@ static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
  *	-EINVAL:  NOT FOUND
  *	0..csrow = Chip-Select Row
  */
-static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
+static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
@@ -1701,7 +1701,7 @@ static struct amd64_family_type amd64_family_types[] = {
  *
  * Algorithm courtesy of Ross LaFetra from AMD.
  */
-static u16 x4_vectors[] = {
+static const u16 x4_vectors[] = {
 	0x2f57, 0x1afe, 0x66cc, 0xdd88,
 	0x11eb, 0x3396, 0x7f4c, 0xeac8,
 	0x0001, 0x0002, 0x0004, 0x0008,
@@ -1740,7 +1740,7 @@ static u16 x4_vectors[] = {
 	0x19a9, 0x2efe, 0xb5cc, 0x6f88,
 };
 
-static u16 x8_vectors[] = {
+static const u16 x8_vectors[] = {
 	0x0145, 0x028a, 0x2374, 0x43c8, 0xa1f0, 0x0520, 0x0a40, 0x1480,
 	0x0211, 0x0422, 0x0844, 0x1088, 0x01b0, 0x44e0, 0x23c0, 0xed80,
 	0x1011, 0x0116, 0x022c, 0x0458, 0x08b0, 0x8c60, 0x2740, 0x4e80,
@@ -1762,7 +1762,7 @@ static u16 x8_vectors[] = {
 	0x0100, 0x0200, 0x0400, 0x0800, 0x1000, 0x2000, 0x4000, 0x8000,
 };
 
-static int decode_syndrome(u16 syndrome, u16 *vectors, unsigned num_vecs,
+static int decode_syndrome(u16 syndrome, const u16 *vectors, unsigned num_vecs,
 			   unsigned v_dim)
 {
 	unsigned int i, err_sym;
@@ -2196,7 +2196,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
+static bool amd64_nb_mce_bank_enabled_on_node(u16 nid)
 {
 	cpumask_var_t mask;
 	int cpu, nbe;
@@ -2229,7 +2229,7 @@ out:
 	return ret;
 }
 
-static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
+static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2267,7 +2267,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 	return 0;
 }
 
-static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 				       struct pci_dev *F3)
 {
 	bool ret = true;
@@ -2319,7 +2319,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	return ret;
 }
 
-static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 					struct pci_dev *F3)
 {
 	u32 value, mask = 0x3;		/* UECC/CECC enable */
@@ -2358,7 +2358,7 @@ static const char *ecc_msg =
 	"'ecc_enable_override'.\n"
 	" (Note that use of the override may cause unknown side effects.)\n";
 
-static bool ecc_enabled(struct pci_dev *F3, u8 nid)
+static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 {
 	u32 value;
 	u8 ecc_en = 0;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index cd7845f..35637d8 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -334,7 +334,7 @@ struct amd64_pvt {
 	/* pci_device handles which we utilize */
 	struct pci_dev *F1, *F2, *F3;
 
-	unsigned mc_node_id;	/* MC index of this MC node */
+	u16 mc_node_id;		/* MC index of this MC node */
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
@@ -387,7 +387,7 @@ struct err_info {
 	u32 offset;
 };
 
-static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
+static inline u64 get_dram_base(struct amd64_pvt *pvt, u8 i)
 {
 	u64 addr = ((u64)pvt->ranges[i].base.lo & 0xffff0000) << 8;
 
@@ -397,7 +397,7 @@ static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
 	return (((u64)pvt->ranges[i].base.hi & 0x000000ff) << 40) | addr;
 }
 
-static inline u64 get_dram_limit(struct amd64_pvt *pvt, unsigned i)
+static inline u64 get_dram_limit(struct amd64_pvt *pvt, u8 i)
 {
 	u64 lim = (((u64)pvt->ranges[i].lim.lo & 0xffff0000) << 8) | 0x00ffffff;
 
