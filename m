Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbaGSJ4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:56:17 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63551 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760695AbaGSJz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:55:57 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/4] Fix blank lines issue reported by checkpatch
Date: Sat, 19 Jul 2014 11:55:43 +0200
Message-Id: <1405763743-30023-5-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405763743-30023-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1405763743-30023-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/staging/sep/sep_main.c | 47 ++++--------------------------------------
 1 file changed, 4 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 6f98881..89a1d53 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -492,7 +492,6 @@ int sep_free_dma_table_data_handler(struct sep_device *sep,
 		 * memory is not available to the o/s at all.
 		 */
 		if (!(*dma_ctx)->secure_dma && dma->out_map_array) {
-
 			for (count = 0; count < dma->out_num_pages; count++) {
 				dma_unmap_page(&sep->pdev->dev,
 					dma->out_map_array[count].dma_addr,
@@ -513,7 +512,6 @@ int sep_free_dma_table_data_handler(struct sep_device *sep,
 
 		/* Again, we do this only for non secure dma */
 		if (!(*dma_ctx)->secure_dma && dma->out_page_array) {
-
 			for (count = 0; count < dma->out_num_pages; count++) {
 				if (!PageReserved(dma->out_page_array[count]))
 
@@ -633,7 +631,6 @@ static int sep_end_transaction_handler(struct sep_device *sep,
 	return 0;
 }
 
-
 /**
  * sep_release - close a SEP device
  * @inode: inode of SEP device
@@ -766,7 +763,6 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 		goto end_function;
 	}
 
-
 	/* Add the event to the polling wait table */
 	dev_dbg(&sep->pdev->dev, "[PID%d] poll: calling wait sep_event\n",
 					current->pid);
@@ -856,7 +852,6 @@ static unsigned long sep_set_time(struct sep_device *sep)
 	struct timeval time;
 	u32 *time_addr;	/* Address of time as seen by the kernel */
 
-
 	do_gettimeofday(&time);
 
 	/* Set value in the SYSTEM MEMORY offset */
@@ -905,7 +900,6 @@ int sep_send_command_handler(struct sep_device *sep)
 	msg_pool += 1;
 	if ((*msg_pool < 2) ||
 		(*msg_pool > SEP_DRIVER_MAX_MESSAGE_SIZE_IN_BYTES)) {
-
 		dev_warn(&sep->pdev->dev, "invalid message size\n");
 		error = -EPROTO;
 		goto end_function;
@@ -1023,7 +1017,6 @@ static int sep_crypto_dma(
 
 	*dma_maps = sep_dma;
 	return count_mapped;
-
 }
 
 /**
@@ -1053,7 +1046,6 @@ static int sep_crypto_lli(
 	u32 data_size,
 	enum dma_data_direction direction)
 {
-
 	int ct1;
 	struct sep_lli_entry *sep_lli;
 	struct sep_dma_map *sep_map;
@@ -1318,7 +1310,6 @@ static int sep_lock_user_pages(struct sep_device *sep,
 			(unsigned long)lli_array[0].bus_address,
 			lli_array[0].block_size);
 
-
 	/* Check the size of the last page */
 	if (num_pages > 1) {
 		lli_array[num_pages - 1].block_size =
@@ -1663,7 +1654,6 @@ static void sep_build_lli_table(struct sep_device *sep,
 
 	/* Set the output parameter */
 	*num_processed_entries_ptr += array_counter;
-
 }
 
 /**
@@ -1747,7 +1737,6 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 		/* Print entries of the table (without info entry) */
 		for (entries_count = 0; entries_count < num_table_entries;
 			entries_count++, lli_table_ptr++) {
-
 			dev_dbg(&sep->pdev->dev,
 				"[PID%d] lli_table_ptr address is %08lx\n",
 				current->pid,
@@ -1773,7 +1762,6 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 			current->pid,
 			(unsigned long)lli_table_ptr->bus_address);
 
-
 		table_data_size = lli_table_ptr->block_size & 0xffffff;
 		num_table_entries = (lli_table_ptr->block_size >> 24) & 0xff;
 
@@ -1796,7 +1784,6 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 #endif
 }
 
-
 /**
  * sep_prepare_empty_lli_table - create a blank LLI table
  * @sep: pointer to struct sep_device
@@ -1972,7 +1959,6 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 
 	/* Loop till all the entries in in array are processed */
 	while (current_entry < sep_lli_entries) {
-
 		/* Set the new input and output tables */
 		in_lli_table_ptr =
 			(struct sep_lli_entry *)lli_table_alloc_addr;
@@ -1988,10 +1974,8 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 			((void *)sep->shared_addr +
 			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
-
 			error = -ENOMEM;
 			goto end_function_error;
-
 		}
 
 		/* Update the number of created tables */
@@ -2022,7 +2006,6 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 			&current_entry, &num_entries_in_table, table_data_size);
 
 		if (info_entry_ptr == NULL) {
-
 			/* Set the output parameters to physical addresses */
 			*lli_table_ptr = sep_shared_area_virt_to_bus(sep,
 				dma_in_lli_table_ptr);
@@ -2071,7 +2054,6 @@ end_function_error:
 
 end_function:
 	return error;
-
 }
 
 /**
@@ -2193,7 +2175,6 @@ static int sep_construct_dma_tables_from_lli(
 			((void *)sep->shared_addr +
 			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
-
 			dev_warn(&sep->pdev->dev, "dma table limit overrun\n");
 			return -ENOMEM;
 		}
@@ -2450,10 +2431,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 
 			goto end_function_free_lli_in;
 		}
-
-	}
-
-	else {
+	} else {
 		dev_dbg(&sep->pdev->dev, "[PID%d] Locking user input pages\n",
 						current->pid);
 		error = sep_lock_user_pages(sep, app_virt_in_addr,
@@ -2554,7 +2532,6 @@ end_function_with_error:
 	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_page_array = NULL;
 	kfree(lli_out_array);
 
-
 end_function_free_lli_in:
 	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array);
 	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array = NULL;
@@ -2563,9 +2540,7 @@ end_function_free_lli_in:
 	kfree(lli_in_array);
 
 end_function:
-
 	return error;
-
 }
 
 /**
@@ -2703,7 +2678,6 @@ int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	dcb_table_ptr->out_vr_tail_pt = 0;
 
 	if (isapplet) {
-
 		/* Check if there is enough data for DMA operation */
 		if (data_in_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE) {
 			if (is_kva) {
@@ -2829,10 +2803,8 @@ end_function_error:
 
 end_function:
 	return error;
-
 }
 
-
 /**
  * sep_free_dma_tables_and_dcb - free DMA tables and DCBs
  * @sep: pointer to struct sep_device
@@ -2963,7 +2935,6 @@ static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg,
 
 end_function:
 	return error;
-
 }
 
 /**
@@ -3167,7 +3138,6 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 	dev_dbg(&sep->pdev->dev, "sep int: IRR REG val: %x\n", reg_val);
 
 	if (reg_val & (0x1 << 13)) {
-
 		/* Lock and update the counter of reply messages */
 		spin_lock_irqsave(&sep->snd_rply_lck, lock_irq_flag);
 		sep->reply_ct++;
@@ -3244,8 +3214,9 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
 		dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
 		dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
 		ret_val = -ENOMEM;
-	} else
+	} else {
 		ret_val = 0;
+	}
 
 	dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
 
@@ -3432,7 +3403,6 @@ static ssize_t sep_create_dcb_dmatables_context(struct sep_device *sep,
 end_function:
 	kfree(dcb_args);
 	return error;
-
 }
 
 /**
@@ -3511,7 +3481,6 @@ int sep_create_dcb_dmatables_context_kernel(struct sep_device *sep,
 
 end_function:
 	return error;
-
 }
 
 /**
@@ -3590,7 +3559,6 @@ end_function:
 	return error;
 }
 
-
 /**
  *	sep_read - Returns results of an operation for fastcall interface
  *	@filp: File pointer
@@ -3638,7 +3606,6 @@ static ssize_t sep_read(struct file *filp,
 		goto end_function_error;
 	}
 
-
 	/* Wait for SEP to finish */
 	wait_event(sep->event_interrupt,
 		   test_bit(SEP_WORKING_LOCK_BIT,
@@ -3711,7 +3678,6 @@ static inline ssize_t sep_fastcall_args_get(struct sep_device *sep,
 		goto end_function;
 	}
 
-
 	if (copy_from_user(args, buf_user, sizeof(struct sep_fastcall_hdr))) {
 		error = -EFAULT;
 		goto end_function;
@@ -3813,7 +3779,6 @@ static ssize_t sep_write(struct file *filp,
 		goto end_function_error;
 	}
 
-
 	/*
 	 * Prepare contents of the shared area regions for
 	 * the operation into temporary buffers
@@ -3923,6 +3888,7 @@ end_function:
 
 	return error;
 }
+
 /**
  *	sep_seek - Handler for seek system call
  *	@filp: File pointer
@@ -3937,8 +3903,6 @@ static loff_t sep_seek(struct file *filp, loff_t offset, int origin)
 	return -ENOSYS;
 }
 
-
-
 /**
  * sep_file_operations - file operation on sep device
  * @sep_ioctl:	ioctl handler from user space call
@@ -3991,7 +3955,6 @@ sep_sysfs_read(struct file *filp, struct kobject *kobj,
 	if (queue_num > SEP_DOUBLEBUF_USERS_LIMIT)
 		queue_num = SEP_DOUBLEBUF_USERS_LIMIT;
 
-
 	if (count < sizeof(queue_num)
 			+ (queue_num * sizeof(struct sep_queue_data))) {
 		spin_unlock_irqrestore(&sep->sep_queue_lock, lck_flags);
@@ -4061,7 +4024,6 @@ static int sep_register_driver_with_fs(struct sep_device *sep)
 	return ret_val;
 }
 
-
 /**
  *sep_probe - probe a matching PCI device
  *@pdev:	pci_device
@@ -4352,7 +4314,6 @@ static int sep_pci_suspend(struct device *dev)
  */
 static int sep_pm_runtime_resume(struct device *dev)
 {
-
 	u32 retval2;
 	u32 delay_count;
 	struct sep_device *sep = sep_dev;
-- 
1.8.5.5

