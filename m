Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaFFEyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 00:54:33 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44104 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaFFEyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 00:54:31 -0400
Message-ID: <5391497D.8040800@gmail.com>
Date: Fri, 06 Jun 2014 10:24:21 +0530
From: Adithya <linux.challenge1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        ody.guru@gmail.com, dan.carpenter@oracle.com, freemangordon@abv.bg,
        rashika.kheria@gmail.com, gregkh@linuxfoundation.org,
        omar.ramirez@copitl.com
CC: linux.challenge1@gmail.com
Subject: [PATCH 1/1] Staging:tidspbridge Fix minor checkpatch.pl warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adithya K<linux.challenge1@gmail.com>

Fixed checkpatch "WARNING: Missing a blank line after declarations"

Signed-off-by: Adithya Krishnamurthy<linux.challenge1@gmail.com>
---
  drivers/staging/tidspbridge/core/chnl_sm.c       |    1 +
  drivers/staging/tidspbridge/core/io_sm.c         |    1 +
  drivers/staging/tidspbridge/core/tiomap3430.c    |    2 ++
  drivers/staging/tidspbridge/core/tiomap_io.c     |    2 ++
  drivers/staging/tidspbridge/core/wdt.c           |    1 +
  drivers/staging/tidspbridge/dynload/cload.c      |    7 +++++++
  drivers/staging/tidspbridge/dynload/reloc.c      |    2 ++
  drivers/staging/tidspbridge/gen/gh.c             |    1 +
  drivers/staging/tidspbridge/pmgr/chnl.c          |    1 +
  drivers/staging/tidspbridge/rmgr/dbdcd.c         |    1 +
  drivers/staging/tidspbridge/rmgr/drv_interface.c |    2 ++
  drivers/staging/tidspbridge/rmgr/nldr.c          |    1 +
  drivers/staging/tidspbridge/rmgr/node.c          |    2 ++
  drivers/staging/tidspbridge/rmgr/proc.c          |    3 +++
  14 files changed, 27 insertions(+)

diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index 16fa346..c855992 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -486,6 +486,7 @@ int bridge_chnl_get_info(struct chnl_object *chnl_obj,
  {
  	int status = 0;
  	struct chnl_object *pchnl = (struct chnl_object *)chnl_obj;
+
  	if (channel_info != NULL) {
  		if (pchnl) {
  			/* Return the requested information: */
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index c2829aa..42f94e1 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -249,6 +249,7 @@ int bridge_io_create(struct io_mgr **io_man,
  int bridge_io_destroy(struct io_mgr *hio_mgr)
  {
  	int status = 0;
+
  	if (hio_mgr) {
  		/* Free IO DPC object */
  		tasklet_kill(&hio_mgr->dpc_tasklet);
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 8945b4e..bf952ef 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -1057,6 +1057,7 @@ static int bridge_brd_mem_copy(struct bridge_dev_context *dev_ctxt,
  	u32 total_bytes = ul_num_bytes;
  	u8 host_buf[BUFFERSIZE];
  	struct bridge_dev_context *dev_context = dev_ctxt;
+
  	while (total_bytes > 0 && !status) {
  		copy_bytes =
  		    total_bytes > BUFFERSIZE ? BUFFERSIZE : total_bytes;
@@ -1094,6 +1095,7 @@ static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
  	struct bridge_dev_context *dev_context = dev_ctxt;
  	u32 ul_remain_bytes = 0;
  	u32 ul_bytes = 0;
+
  	ul_remain_bytes = ul_num_bytes;
  	while (ul_remain_bytes > 0 && !status) {
  		ul_bytes =
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index f53ed98..2836467 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -176,6 +176,7 @@ int write_dsp_data(struct bridge_dev_context *dev_context,
  	struct cfg_hostres *resources = dev_context->resources;
  	int status = 0;
  	u32 base1, base2, base3;
+
  	base1 = OMAP_DSP_MEM1_SIZE;
  	base2 = OMAP_DSP_MEM2_BASE - OMAP_DSP_MEM1_BASE;
  	base3 = OMAP_DSP_MEM3_BASE - OMAP_DSP_MEM1_BASE;
@@ -229,6 +230,7 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
  	u32 ul_shm_offset_virt = 0;
  	struct cfg_hostres *host_res = dev_context->resources;
  	bool trace_load = false;
+
  	temp_byte1 = 0x0;
  	temp_byte2 = 0x0;
  
diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
index c7ee467..b19f887 100644
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@ -33,6 +33,7 @@ static struct dsp_wdt_setting dsp_wdt;
  void dsp_wdt_dpc(unsigned long data)
  {
  	struct deh_mgr *deh_mgr;
+
  	dev_get_deh_mgr(dev_get_first(), &deh_mgr);
  	if (deh_mgr)
  		bridge_deh_notify(deh_mgr, DSP_WDTOVERFLOW, 0);
diff --git a/drivers/staging/tidspbridge/dynload/cload.c b/drivers/staging/tidspbridge/dynload/cload.c
index 9d54744..83f2106 100644
--- a/drivers/staging/tidspbridge/dynload/cload.c
+++ b/drivers/staging/tidspbridge/dynload/cload.c
@@ -160,6 +160,7 @@ int dynamic_load_module(struct dynamic_loader_stream *module,
  		if (!dl_state.dload_errcount) {
  			/* fix up entry point address */
  			unsigned sref = dl_state.dfile_hdr.df_entry_secn - 1;
+
  			if (sref < dl_state.allocated_secn_count)
  				dl_state.dfile_hdr.df_entrypt +=
  				    dl_state.ldr_sections[sref].run_addr;
@@ -269,6 +270,7 @@ dynamic_open_module(struct dynamic_loader_stream *module,
  		if (!dl_state.dload_errcount) {
  			/* fix up entry point address */
  			unsigned sref = dl_state.dfile_hdr.df_entry_secn - 1;
+
  			if (sref < dl_state.allocated_secn_count)
  				dl_state.dfile_hdr.df_entrypt +=
  				    dl_state.ldr_sections[sref].run_addr;
@@ -476,6 +478,7 @@ static void allocate_sections(struct dload_state *dlthis)
  	struct doff_scnhdr_t *shp;
  	struct ldr_section_info *asecs;
  	struct my_handle *hndl;
+
  	nsecs = dlthis->dfile_hdr.df_no_scns;
  	if (!nsecs)
  		return;
@@ -1089,6 +1092,7 @@ static int relocate_packet(struct dload_state *dlthis,
  		unsigned rinbuf;
  		int siz;
  		struct reloc_record_t *rp, rrec[MY_RELOC_BUF_SIZ];
+
  		rp = rrec;
  		rinbuf = rnum > MY_RELOC_BUF_SIZ ? MY_RELOC_BUF_SIZ : rnum;
  		siz = rinbuf * sizeof(struct reloc_record_t);
@@ -1502,6 +1506,7 @@ static void swap_words(void *data, unsigned siz, unsigned bitmap)
  	sp = (u16 *) data;
  	do {
  		register u16 tmp;
+
  		tmp = *sp;
  		*sp++ = SWAP16BY8(tmp);
  	} while ((i -= 1) > 0);
@@ -1543,6 +1548,7 @@ static char *copy_tgt_strings(void *dstp, void *srcp, unsigned charcount)
  	register tgt_au_t *src = (tgt_au_t *) srcp;
  	register tgt_au_t *dst = (tgt_au_t *) dstp;
  	register int cnt = charcount;
+
  	do {
  #if TARGET_AU_BITS <= BITS_PER_AU
  		/* byte-swapping issues may exist for strings on target */
@@ -1598,6 +1604,7 @@ static void init_module_handle(struct dload_state *dlthis)
  	struct modules_header mhdr;
  	struct ldr_section_info dllview_info;
  	struct dynload_symbol *debug_mirror_sym;
+
  	hndl = dlthis->myhandle;
  	if (!hndl)
  		return;		/* must be errors detected, so forget it */
diff --git a/drivers/staging/tidspbridge/dynload/reloc.c b/drivers/staging/tidspbridge/dynload/reloc.c
index 463abdb..bb422b6 100644
--- a/drivers/staging/tidspbridge/dynload/reloc.c
+++ b/drivers/staging/tidspbridge/dynload/reloc.c
@@ -135,6 +135,7 @@ int dload_repack(struct dload_state *dlthis, rvalue val, tgt_au_t *data,
  	 */
  	if (sgn) {
  		unsigned tmp = (val >> fieldsz) + (sgn & 0x1);
+
  		if (tmp > ovf_limit[sgn - 1])
  			return 1;
  	}
@@ -403,6 +404,7 @@ void dload_relocate(struct dload_state *dlthis, tgt_au_t *data,
  	case RACT_C6BASE:
  		if (dlthis->bss_run_base == 0) {
  			struct dynload_symbol *symp;
+
  			symp = dlthis->mysym->find_matching_symbol
  			    (dlthis->mysym, bsssymbol);
  			/* lookup value of global BSS base */
diff --git a/drivers/staging/tidspbridge/gen/gh.c b/drivers/staging/tidspbridge/gen/gh.c
index 936470c..a3da25c 100644
--- a/drivers/staging/tidspbridge/gen/gh.c
+++ b/drivers/staging/tidspbridge/gen/gh.c
@@ -28,6 +28,7 @@ struct gh_node {
  struct gh_t_hash_tab {
  	u32 val_size;
  	DECLARE_HASHTABLE(hash_table, GH_HASH_ORDER);
+
  	u32 (*hash)(const void *key);
  	bool (*match)(const void *key, const void *value);
  	void (*delete)(void *key);
diff --git a/drivers/staging/tidspbridge/pmgr/chnl.c b/drivers/staging/tidspbridge/pmgr/chnl.c
index 4bd8686..e03c326 100644
--- a/drivers/staging/tidspbridge/pmgr/chnl.c
+++ b/drivers/staging/tidspbridge/pmgr/chnl.c
@@ -75,6 +75,7 @@ int chnl_create(struct chnl_mgr **channel_mgr,
  
  	if (!status) {
  		struct bridge_drv_interface *intf_fxns;
+
  		dev_get_intf_fxns(hdev_obj, &intf_fxns);
  		/* Let Bridge channel module finish the create: */
  		status = (*intf_fxns->chnl_create) (&hchnl_mgr, hdev_obj,
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 2ae48c9..c91d1d7 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -489,6 +489,7 @@ int dcd_get_object_def(struct dcd_manager *hdcd_mgr,
  	strncpy(sz_sect_name, ".", 2);
  	do {
  		char *uuid = strsep(&tmp, "-");
+
  		if (!uuid)
  			break;
  		len -= strlen(uuid);
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 74d31da..e3918d2 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -351,6 +351,7 @@ static void bridge_recover(struct work_struct *work)
  {
  	struct dev_object *dev;
  	struct cfg_devnode *dev_node;
+
  	if (atomic_read(&bridge_cref)) {
  		reinit_completion(&bridge_comp);
  		while (!wait_for_completion_timeout(&bridge_comp,
@@ -638,6 +639,7 @@ int drv_remove_all_resources(void *process_ctxt)
  {
  	int status = 0;
  	struct process_context *ctxt = (struct process_context *)process_ctxt;
+
  	drv_remove_all_strm_res_elements(ctxt);
  	drv_remove_all_node_res_elements(ctxt);
  	drv_remove_all_dmm_res_elements(ctxt);
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 5ac507c..900585a 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -1542,6 +1542,7 @@ static int remote_alloc(void **ref, u16 mem_sect, u32 size,
  	struct rmm_addr *rmm_addr_obj = (struct rmm_addr *)dsp_address;
  	bool mem_load_req = false;
  	int status = -ENOMEM;	/* Set to fail */
+
  	nldr_obj = hnode->nldr_obj;
  	rmm = nldr_obj->rmm;
  	/* Convert size to DSP words */
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 9d3044a..133f2db 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -273,6 +273,7 @@ static struct node_ldr_fxns nldr_fxns = {
  enum node_state node_get_state(void *hnode)
  {
  	struct node_object *pnode = (struct node_object *)hnode;
+
  	if (!pnode)
  		return -1;
  	return pnode->node_state;
@@ -2365,6 +2366,7 @@ static void delete_node(struct node_object *hnode,
  	    (struct proc_object *)hnode->processor;
  #endif
  	int status;
+
  	if (!hnode)
  		goto func_end;
  	hnode_mgr = hnode->node_mgr;
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index cd5235a..23e5146 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -200,6 +200,7 @@ static struct dmm_map_object *find_containing_mapping(
  				u32 mpu_addr, u32 size)
  {
  	struct dmm_map_object *map_obj;
+
  	pr_debug("%s: looking for mpu_addr 0x%x size 0x%x\n", __func__,
  						mpu_addr, size);
  
@@ -985,6 +986,7 @@ int proc_get_state(void *hprocessor,
  int proc_get_trace(void *hprocessor, u8 *pbuf, u32 max_size)
  {
  	int status;
+
  	status = -ENOSYS;
  	return status;
  }
@@ -1737,6 +1739,7 @@ static int proc_monitor(struct proc_object *proc_obj)
  static s32 get_envp_count(char **envp)
  {
  	s32 ret = 0;
+
  	if (envp) {
  		while (*envp++)
  			ret++;
-- 
1.7.9.5

