Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866AbaD2Q7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:59:25 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57803 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbaD2Q7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:59:22 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] staging: android: fix missing a blank line after declarations
Date: Wed, 30 Apr 2014 01:59:12 +0900
Message-Id: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes "Missing a blank line after declarations" warnings.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/android/alarm-dev.c           |    1 +
 drivers/staging/android/binder.c              |   37 +++++++++++++++++++++++++
 drivers/staging/android/ion/ion.c             |   10 +++++++
 drivers/staging/android/ion/ion_heap.c        |    2 ++
 drivers/staging/android/ion/ion_priv.h        |    1 +
 drivers/staging/android/ion/ion_system_heap.c |    5 ++++
 drivers/staging/android/logger.c              |    3 ++
 drivers/staging/android/sw_sync.c             |    2 ++
 drivers/staging/android/sync.c                |    8 ++++++
 drivers/staging/android/timed_gpio.c          |    1 +
 10 files changed, 70 insertions(+)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 2fc7cdd..f200e8a 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -329,6 +329,7 @@ static int alarm_release(struct inode *inode, struct file *file)
 	if (file->private_data) {
 		for (i = 0; i < ANDROID_ALARM_TYPE_COUNT; i++) {
 			uint32_t alarm_type_mask = 1U << i;
+
 			if (alarm_enabled & alarm_type_mask) {
 				alarm_dbg(INFO,
 					  "%s: clear alarm, pending %d\n",
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index fc59281..8220304 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -118,6 +118,7 @@ static int binder_set_stop_on_user_error(const char *val,
 					 struct kernel_param *kp)
 {
 	int ret;
+
 	ret = param_set_int(val, kp);
 	if (binder_stop_on_user_error < 2)
 		wake_up(&binder_user_error_wait);
@@ -194,6 +195,7 @@ static struct binder_transaction_log_entry *binder_transaction_log_add(
 	struct binder_transaction_log *log)
 {
 	struct binder_transaction_log_entry *e;
+
 	e = &log->entry[log->next];
 	memset(e, 0, sizeof(*e));
 	log->next++;
@@ -228,8 +230,10 @@ struct binder_node {
 	int internal_strong_refs;
 	int local_weak_refs;
 	int local_strong_refs;
+
 	binder_uintptr_t ptr;
 	binder_uintptr_t cookie;
+
 	unsigned has_strong_ref:1;
 	unsigned pending_strong_ref:1;
 	unsigned has_weak_ref:1;
@@ -432,6 +436,7 @@ static inline void binder_unlock(const char *tag)
 static void binder_set_nice(long nice)
 {
 	long min_nice;
+
 	if (can_nice(current, nice)) {
 		set_user_nice(current, nice);
 		return;
@@ -584,6 +589,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 	for (page_addr = start; page_addr < end; page_addr += PAGE_SIZE) {
 		int ret;
 		struct page **page_array_ptr;
+
 		page = &proc->pages[(page_addr - proc->buffer) / PAGE_SIZE];
 
 		BUG_ON(*page);
@@ -726,6 +732,7 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 	binder_insert_allocated_buffer(proc, buffer);
 	if (buffer_size != size) {
 		struct binder_buffer *new_buffer = (void *)buffer->data + size;
+
 		list_add(&new_buffer->entry, &buffer->entry);
 		new_buffer->free = 1;
 		binder_insert_free_buffer(proc, new_buffer);
@@ -778,6 +785,7 @@ static void binder_delete_free_buffer(struct binder_proc *proc,
 	if (!list_is_last(&buffer->entry, &proc->buffers)) {
 		next = list_entry(buffer->entry.next,
 				  struct binder_buffer, entry);
+
 		if (buffer_start_page(next) == buffer_end_page(buffer)) {
 			free_page_end = 0;
 			if (buffer_start_page(next) ==
@@ -838,6 +846,7 @@ static void binder_free_buf(struct binder_proc *proc,
 	if (!list_is_last(&buffer->entry, &proc->buffers)) {
 		struct binder_buffer *next = list_entry(buffer->entry.next,
 						struct binder_buffer, entry);
+
 		if (next->free) {
 			rb_erase(&next->rb_node, &proc->free_buffers);
 			binder_delete_free_buffer(proc, next);
@@ -846,6 +855,7 @@ static void binder_free_buf(struct binder_proc *proc,
 	if (proc->buffers.next != &buffer->entry) {
 		struct binder_buffer *prev = list_entry(buffer->entry.prev,
 						struct binder_buffer, entry);
+
 		if (prev->free) {
 			binder_delete_free_buffer(proc, buffer);
 			rb_erase(&prev->rb_node, &proc->free_buffers);
@@ -1107,6 +1117,7 @@ static int binder_inc_ref(struct binder_ref *ref, int strong,
 			  struct list_head *target_list)
 {
 	int ret;
+
 	if (strong) {
 		if (ref->strong == 0) {
 			ret = binder_inc_node(ref->node, 1, 1, target_list);
@@ -1138,6 +1149,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 		ref->strong--;
 		if (ref->strong == 0) {
 			int ret;
+
 			ret = binder_dec_node(ref->node, strong, 1);
 			if (ret)
 				return ret;
@@ -1177,6 +1189,7 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 				     uint32_t error_code)
 {
 	struct binder_thread *target_thread;
+
 	BUG_ON(t->flags & TF_ONE_WAY);
 	while (1) {
 		target_thread = t->from;
@@ -1247,6 +1260,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		off_end = (void *)offp + buffer->offsets_size;
 	for (; offp < off_end; offp++) {
 		struct flat_binder_object *fp;
+
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(u32))) {
@@ -1259,6 +1273,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
 			struct binder_node *node = binder_get_node(proc, fp->binder);
+
 			if (node == NULL) {
 				pr_err("transaction release %d bad node %016llx\n",
 				       debug_id, (u64)fp->binder);
@@ -1272,6 +1287,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_HANDLE:
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
+
 			if (ref == NULL) {
 				pr_err("transaction release %d bad handle %d\n",
 				 debug_id, fp->handle);
@@ -1363,6 +1379,7 @@ static void binder_transaction(struct binder_proc *proc,
 	} else {
 		if (tr->target.handle) {
 			struct binder_ref *ref;
+
 			ref = binder_get_ref(proc, tr->target.handle);
 			if (ref == NULL) {
 				binder_user_error("%d:%d got transaction to invalid handle\n",
@@ -1386,6 +1403,7 @@ static void binder_transaction(struct binder_proc *proc,
 		}
 		if (!(tr->flags & TF_ONE_WAY) && thread->transaction_stack) {
 			struct binder_transaction *tmp;
+
 			tmp = thread->transaction_stack;
 			if (tmp->to_thread != thread) {
 				binder_user_error("%d:%d got new transaction with bad transaction stack, transaction %d has target %d:%d\n",
@@ -1501,6 +1519,7 @@ static void binder_transaction(struct binder_proc *proc,
 	off_end = (void *)offp + tr->offsets_size;
 	for (; offp < off_end; offp++) {
 		struct flat_binder_object *fp;
+
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(u32))) {
@@ -1515,6 +1534,7 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_BINDER: {
 			struct binder_ref *ref;
 			struct binder_node *node = binder_get_node(proc, fp->binder);
+
 			if (node == NULL) {
 				node = binder_new_node(proc, fp->binder, fp->cookie);
 				if (node == NULL) {
@@ -1553,6 +1573,7 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_HANDLE:
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
+
 			if (ref == NULL) {
 				binder_user_error("%d:%d got transaction with invalid handle, %d\n",
 						proc->pid,
@@ -1575,6 +1596,7 @@ static void binder_transaction(struct binder_proc *proc,
 					     (u64)ref->node->ptr);
 			} else {
 				struct binder_ref *new_ref;
+
 				new_ref = binder_get_ref_for_node(target_proc, ref->node);
 				if (new_ref == NULL) {
 					return_error = BR_FAILED_REPLY;
@@ -1694,6 +1716,7 @@ err_no_context_mgr_node:
 
 	{
 		struct binder_transaction_log_entry *fe;
+
 		fe = binder_transaction_log_add(&binder_transaction_log_failed);
 		*fe = *e;
 	}
@@ -2024,12 +2047,14 @@ static int binder_thread_write(struct binder_proc *proc,
 			struct binder_work *w;
 			binder_uintptr_t cookie;
 			struct binder_ref_death *death = NULL;
+
 			if (get_user(cookie, (binder_uintptr_t __user *)ptr))
 				return -EFAULT;
 
 			ptr += sizeof(void *);
 			list_for_each_entry(w, &proc->delivered_death, entry) {
 				struct binder_ref_death *tmp_death = container_of(w, struct binder_ref_death, work);
+
 				if (tmp_death->cookie == cookie) {
 					death = tmp_death;
 					break;
@@ -2216,6 +2241,7 @@ retry:
 			const char *cmd_name;
 			int strong = node->internal_strong_refs || node->local_strong_refs;
 			int weak = !hlist_empty(&node->refs) || node->local_weak_refs || strong;
+
 			if (weak && !node->has_weak_ref) {
 				cmd = BR_INCREFS;
 				cmd_name = "BR_INCREFS";
@@ -2322,6 +2348,7 @@ retry:
 		BUG_ON(t->buffer == NULL);
 		if (t->buffer->target_node) {
 			struct binder_node *target_node = t->buffer->target_node;
+
 			tr.target.ptr = target_node->ptr;
 			tr.cookie =  target_node->cookie;
 			t->saved_priority = task_nice(current);
@@ -2343,6 +2370,7 @@ retry:
 
 		if (t->from) {
 			struct task_struct *sender = t->from->proc->tsk;
+
 			tr.sender_pid = task_tgid_nr_ns(sender,
 							task_active_pid_ns(current));
 		} else {
@@ -2413,6 +2441,7 @@ done:
 static void binder_release_work(struct list_head *list)
 {
 	struct binder_work *w;
+
 	while (!list_empty(list)) {
 		w = list_first_entry(list, struct binder_work, entry);
 		list_del_init(&w->entry);
@@ -2593,6 +2622,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case BINDER_WRITE_READ: {
 		struct binder_write_read bwr;
+
 		if (size != sizeof(struct binder_write_read)) {
 			ret = -EINVAL;
 			goto err;
@@ -2717,6 +2747,7 @@ err_unlocked:
 static void binder_vma_open(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
+
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
 		     "%d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n",
 		     proc->pid, vma->vm_start, vma->vm_end,
@@ -2727,6 +2758,7 @@ static void binder_vma_open(struct vm_area_struct *vma)
 static void binder_vma_close(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
+
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
 		     "%d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n",
 		     proc->pid, vma->vm_start, vma->vm_end,
@@ -2869,6 +2901,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
 
 	if (binder_debugfs_dir_entry_proc) {
 		char strbuf[11];
+
 		snprintf(strbuf, sizeof(strbuf), "%u", proc->pid);
 		proc->debugfs_entry = debugfs_create_file(strbuf, S_IRUGO,
 			binder_debugfs_dir_entry_proc, proc, &binder_proc_fops);
@@ -2890,8 +2923,10 @@ static void binder_deferred_flush(struct binder_proc *proc)
 {
 	struct rb_node *n;
 	int wake_count = 0;
+
 	for (n = rb_first(&proc->threads); n != NULL; n = rb_next(n)) {
 		struct binder_thread *thread = rb_entry(n, struct binder_thread, rb_node);
+
 		thread->looper |= BINDER_LOOPER_STATE_NEED_RETURN;
 		if (thread->looper & BINDER_LOOPER_STATE_WAITING) {
 			wake_up_interruptible(&thread->wait);
@@ -2908,6 +2943,7 @@ static void binder_deferred_flush(struct binder_proc *proc)
 static int binder_release(struct inode *nodp, struct file *filp)
 {
 	struct binder_proc *proc = filp->private_data;
+
 	debugfs_remove(proc->debugfs_entry);
 	binder_defer_work(proc, BINDER_DEFERRED_RELEASE);
 
@@ -3069,6 +3105,7 @@ static void binder_deferred_func(struct work_struct *work)
 	struct files_struct *files;
 
 	int defer;
+
 	do {
 		binder_lock(__func__);
 		mutex_lock(&binder_deferred_lock);
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 3d5bf14..ea2c8a9 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -408,6 +408,7 @@ static struct ion_handle *ion_handle_lookup(struct ion_client *client,
 
 	while (n) {
 		struct ion_handle *entry = rb_entry(n, struct ion_handle, node);
+
 		if (buffer < entry->buffer)
 			n = n->rb_left;
 		else if (buffer > entry->buffer)
@@ -720,9 +721,11 @@ static int ion_get_client_serial(const struct rb_root *root,
 {
 	int serial = -1;
 	struct rb_node *node;
+
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		struct ion_client *client = rb_entry(node, struct ion_client,
 						node);
+
 		if (strcmp(client->name, name))
 			continue;
 		serial = max(serial, client->display_serial);
@@ -1035,12 +1038,14 @@ static int ion_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
 static void ion_dma_buf_release(struct dma_buf *dmabuf)
 {
 	struct ion_buffer *buffer = dmabuf->priv;
+
 	ion_buffer_put(buffer);
 }
 
 static void *ion_dma_buf_kmap(struct dma_buf *dmabuf, unsigned long offset)
 {
 	struct ion_buffer *buffer = dmabuf->priv;
+
 	return buffer->vaddr + offset * PAGE_SIZE;
 }
 
@@ -1292,6 +1297,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case ION_IOC_IMPORT:
 	{
 		struct ion_handle *handle;
+
 		handle = ion_import_dma_buf(client, data.fd.fd);
 		if (IS_ERR(handle))
 			ret = PTR_ERR(handle);
@@ -1393,6 +1399,7 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 		struct ion_client *client = rb_entry(n, struct ion_client,
 						     node);
 		size_t size = ion_debug_heap_total(client, heap->id);
+
 		if (!size)
 			continue;
 		if (client->task) {
@@ -1516,6 +1523,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 
 	if (!debug_file) {
 		char buf[256], *path;
+
 		path = dentry_path(dev->heaps_debug_root, buf, 256);
 		pr_err("Failed to create heap debugfs at %s/%s\n",
 			path, heap->name);
@@ -1531,6 +1539,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 			&debug_shrink_fops);
 		if (!debug_file) {
 			char buf[256], *path;
+
 			path = dentry_path(dev->heaps_debug_root, buf, 256);
 			pr_err("Failed to create heap shrinker debugfs at %s/%s\n",
 				path, debug_name);
@@ -1606,6 +1615,7 @@ void __init ion_reserve(struct ion_platform_data *data)
 
 		if (data->heaps[i].base == 0) {
 			phys_addr_t paddr;
+
 			paddr = memblock_alloc_base(data->heaps[i].size,
 						    data->heaps[i].align,
 						    MEMBLOCK_ALLOC_ANYWHERE);
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index bdc6a28..4605e04 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -48,6 +48,7 @@ void *ion_heap_map_kernel(struct ion_heap *heap,
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		int npages_this_entry = PAGE_ALIGN(sg->length) / PAGE_SIZE;
 		struct page *page = sg_page(sg);
+
 		BUG_ON(i >= npages);
 		for (j = 0; j < npages_this_entry; j++)
 			*(tmp++) = page++;
@@ -105,6 +106,7 @@ int ion_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 static int ion_heap_clear_pages(struct page **pages, int num, pgprot_t pgprot)
 {
 	void *addr = vm_map_ram(pages, num, -1, pgprot);
+
 	if (!addr)
 		return -ENOMEM;
 	memset(addr, 0, PAGE_SIZE * num);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 1eba3f2..c2dc942 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -178,6 +178,7 @@ struct ion_heap {
 	spinlock_t free_lock;
 	wait_queue_head_t waitqueue;
 	struct task_struct *task;
+
 	int (*debug_show)(struct ion_heap *heap, struct seq_file *, void *);
 };
 
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 0663a7f..a144995 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -34,6 +34,7 @@ static const int num_orders = ARRAY_SIZE(orders);
 static int order_to_index(unsigned int order)
 {
 	int i;
+
 	for (i = 0; i < num_orders; i++)
 		if (order == orders[i])
 			return i;
@@ -92,6 +93,7 @@ static void free_buffer_page(struct ion_system_heap *heap,
 
 	if (!cached && !(buffer->private_flags & ION_PRIV_FLAG_SHRINKER_FREE)) {
 		struct ion_page_pool *pool = heap->pools[order_to_index(order)];
+
 		ion_page_pool_free(pool, page);
 	} else {
 		__free_pages(page, order);
@@ -242,6 +244,7 @@ static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
 
 	for (i = 0; i < num_orders; i++) {
 		struct ion_page_pool *pool = sys_heap->pools[i];
+
 		nr_total += ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
 	}
 
@@ -267,8 +270,10 @@ static int ion_system_heap_debug_show(struct ion_heap *heap, struct seq_file *s,
 							struct ion_system_heap,
 							heap);
 	int i;
+
 	for (i = 0; i < num_orders; i++) {
 		struct ion_page_pool *pool = sys_heap->pools[i];
+
 		seq_printf(s, "%d order %u highmem pages in pool = %lu total\n",
 			   pool->high_count, pool->order,
 			   (1 << pool->order) * PAGE_SIZE * pool->high_count);
diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index d42f578..2772e01 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -108,6 +108,7 @@ static inline struct logger_log *file_get_log(struct file *file)
 {
 	if (file->f_mode & FMODE_READ) {
 		struct logger_reader *reader = file->private_data;
+
 		return reader->log;
 	} else
 		return file->private_data;
@@ -124,6 +125,7 @@ static struct logger_entry *get_entry_header(struct logger_log *log,
 		size_t off, struct logger_entry *scratch)
 {
 	size_t len = min(sizeof(struct logger_entry), log->size - off);
+
 	if (len != sizeof(struct logger_entry)) {
 		memcpy(((void *) scratch), log->buffer + off, len);
 		memcpy(((void *) scratch) + len, log->buffer,
@@ -642,6 +644,7 @@ static unsigned int logger_poll(struct file *file, poll_table *wait)
 static long logger_set_version(struct logger_reader *reader, void __user *arg)
 {
 	int version;
+
 	if (copy_from_user(&version, arg, sizeof(int)))
 		return -EFAULT;
 
diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index f24493a..12a136e 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -97,6 +97,7 @@ static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
 				       char *str, int size)
 {
 	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+
 	snprintf(str, size, "%d", pt->value);
 }
 
@@ -156,6 +157,7 @@ static int sw_sync_open(struct inode *inode, struct file *file)
 static int sw_sync_release(struct inode *inode, struct file *file)
 {
 	struct sw_sync_timeline *obj = file->private_data;
+
 	sync_timeline_destroy(&obj->obj);
 	return 0;
 }
diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 3d05f662..1f88c5d 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -384,6 +384,7 @@ static void sync_fence_detach_pts(struct sync_fence *fence)
 
 	list_for_each_safe(pos, n, &fence->pt_list_head) {
 		struct sync_pt *pt = container_of(pos, struct sync_pt, pt_list);
+
 		sync_timeline_remove_pt(pt);
 	}
 }
@@ -394,6 +395,7 @@ static void sync_fence_free_pts(struct sync_fence *fence)
 
 	list_for_each_safe(pos, n, &fence->pt_list_head) {
 		struct sync_pt *pt = container_of(pos, struct sync_pt, pt_list);
+
 		sync_pt_free(pt);
 	}
 }
@@ -827,6 +829,7 @@ static long sync_fence_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
 {
 	struct sync_fence *fence = file->private_data;
+
 	switch (cmd) {
 	case SYNC_IOC_WAIT:
 		return sync_fence_ioctl_wait(fence, arg);
@@ -856,18 +859,21 @@ static const char *sync_status_str(int status)
 static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
 {
 	int status = pt->status;
+
 	seq_printf(s, "  %s%spt %s",
 		   fence ? pt->parent->name : "",
 		   fence ? "_" : "",
 		   sync_status_str(status));
 	if (pt->status) {
 		struct timeval tv = ktime_to_timeval(pt->timestamp);
+
 		seq_printf(s, "@%ld.%06ld", tv.tv_sec, tv.tv_usec);
 	}
 
 	if (pt->parent->ops->timeline_value_str &&
 	    pt->parent->ops->pt_value_str) {
 		char value[64];
+
 		pt->parent->ops->pt_value_str(pt, value, sizeof(value));
 		seq_printf(s, ": %s", value);
 		if (fence) {
@@ -892,6 +898,7 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
 
 	if (obj->ops->timeline_value_str) {
 		char value[64];
+
 		obj->ops->timeline_value_str(obj, value, sizeof(value));
 		seq_printf(s, ": %s", value);
 	} else if (obj->ops->print_obj) {
@@ -1001,6 +1008,7 @@ static void sync_dump(void)
 	for (i = 0; i < s.count; i += DUMP_CHUNK) {
 		if ((s.count - i) > DUMP_CHUNK) {
 			char c = s.buf[i + DUMP_CHUNK];
+
 			s.buf[i + DUMP_CHUNK] = 0;
 			pr_cont("%s", s.buf + i);
 			s.buf[i + DUMP_CHUNK] = c;
diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index 0c7fdc8..f7d124d 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -51,6 +51,7 @@ static int gpio_get_time(struct timed_output_dev *dev)
 	if (hrtimer_active(&data->timer)) {
 		ktime_t r = hrtimer_get_remaining(&data->timer);
 		struct timeval t = ktime_to_timeval(r);
+
 		return t.tv_sec * 1000 + t.tv_usec / 1000;
 	} else
 		return 0;
-- 
1.7.9.5

