Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929Ab3E1RxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:53:19 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:55905 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964881Ab3E1RxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:53:18 -0400
From: Davis Abubakr-Sadik Nii Nai <dwa2pac@gmail.com>
To: gregkh@linuxfoundation.org, develkernel412222@gmail.com,
        williams@redhat.com, standby24x7@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Davis Abubakr-Sadik Nii Nai <dwa2pac@gmail.com>
Subject: [PATCH] Staging: csr: fix indentation style issue in bh.c
Date: Tue, 28 May 2013 17:52:06 +0000
Message-Id: <1369763526-24080-1-git-send-email-dwa2pac@gmail.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the bh.c file that fixes up all indentation errors
found the checkpatch.pl tool. Two lines beyond 80 characters are left
alone to improve readability

Signed-off-by: Davis Abubakr-Sadik Nii Nai <dwa2pac@gmail.com>
---
 drivers/staging/csr/bh.c |  213 ++++++++++++++++++++++++----------------------
 1 files changed, 110 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index b53a9e2..d795852 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -241,67 +241,72 @@ static int bh_thread_function(void *arg)
 	this_thread = &priv->bh_thread;
 
 	t = timeout = 0;
-    while (!kthread_should_stop()) {
-        /* wait until an error occurs, or we need to process something. */
-        unifi_trace(priv, UDBG3, "bh_thread goes to sleep.\n");
-
-        if (timeout > 0) {
-            /* Convert t in ms to jiffies */
-            t = msecs_to_jiffies(timeout);
-            ret = wait_event_interruptible_timeout(this_thread->wakeup_q,
-                    (this_thread->wakeup_flag && !this_thread->block_thread) ||
-                    kthread_should_stop(),
-                    t);
-            timeout = (ret > 0) ? jiffies_to_msecs(ret) : 0;
-        } else {
-            ret = wait_event_interruptible(this_thread->wakeup_q,
-                    (this_thread->wakeup_flag && !this_thread->block_thread) ||
-                    kthread_should_stop());
-        }
-
-        if (kthread_should_stop()) {
-            unifi_trace(priv, UDBG2, "bh_thread: signalled to exit\n");
-            break;
-        }
-
-        if (ret < 0) {
-            unifi_notice(priv,
-                    "bh_thread: wait_event returned %d, thread will exit\n",
-                    ret);
-            uf_wait_for_thread_to_stop(priv, this_thread);
-            break;
-        }
-
-        this_thread->wakeup_flag = 0;
-
-        unifi_trace(priv, UDBG3, "bh_thread calls unifi_bh().\n");
-
-        CsrSdioClaim(priv->sdio);
-        csrResult = unifi_bh(priv->card, &timeout);
-        if(csrResult != CSR_RESULT_SUCCESS) {
-            if (csrResult == CSR_WIFI_HIP_RESULT_NO_DEVICE) {
-                CsrSdioRelease(priv->sdio);
-                uf_wait_for_thread_to_stop(priv, this_thread);
-                break;
-            }
-            /* Errors must be delivered to the error task */
-            handle_bh_error(priv);
-        }
-        CsrSdioRelease(priv->sdio);
-    }
-
-    /*
-     * I would normally try to call csr_sdio_remove_irq() here to make sure
-     * that we do not get any interrupts while this thread is not running.
-     * However, the MMC/SDIO driver tries to kill its' interrupt thread.
-     * The kernel threads implementation does not allow to kill threads
-     * from a signalled to stop thread.
-     * So, instead call csr_sdio_linux_remove_irq() always after calling
-     * uf_stop_thread() to kill this thread.
-     */
-
-    unifi_trace(priv, UDBG2, "bh_thread exiting....\n");
-    return 0;
+	while (!kthread_should_stop()) {
+		/*
+		* wait until an error occurs,
+		* or we need to process something.
+		*/
+		unifi_trace(priv, UDBG3, "bh_thread goes to sleep.\n");
+
+		if (timeout > 0) {
+			/* Convert t in ms to jiffies */
+			t = msecs_to_jiffies(timeout);
+			ret = wait_event_interruptible_timeout(
+				this_thread->wakeup_q,
+				(this_thread->wakeup_flag && !this_thread->block_thread) ||
+				kthread_should_stop(),
+				t);
+			timeout = (ret > 0) ? jiffies_to_msecs(ret) : 0;
+		} else {
+			ret = wait_event_interruptible(this_thread->wakeup_q,
+				(this_thread->wakeup_flag && !this_thread->block_thread) ||
+				kthread_should_stop());
+		}
+
+		if (kthread_should_stop()) {
+			unifi_trace(priv, UDBG2,
+				"bh_thread: signalled to exit\n");
+			break;
+		}
+
+		if (ret < 0) {
+			unifi_notice(priv,
+				"bh_thread: wait_event returned %d, thread will exit\n",
+				ret);
+			uf_wait_for_thread_to_stop(priv, this_thread);
+			break;
+		}
+
+		this_thread->wakeup_flag = 0;
+
+		unifi_trace(priv, UDBG3, "bh_thread calls unifi_bh().\n");
+
+		CsrSdioClaim(priv->sdio);
+		csrResult = unifi_bh(priv->card, &timeout);
+		if (csrResult != CSR_RESULT_SUCCESS) {
+			if (csrResult == CSR_WIFI_HIP_RESULT_NO_DEVICE) {
+				CsrSdioRelease(priv->sdio);
+				uf_wait_for_thread_to_stop(priv, this_thread);
+				break;
+			}
+			/* Errors must be delivered to the error task */
+			handle_bh_error(priv);
+		}
+		CsrSdioRelease(priv->sdio);
+	}
+
+	/*
+	 * I would normally try to call csr_sdio_remove_irq() here to make sure
+	* that we do not get any interrupts while this thread is not running.
+	* However, the MMC/SDIO driver tries to kill its' interrupt thread.
+	* The kernel threads implementation does not allow to kill threads
+	* from a signalled to stop thread.
+	* So, instead call csr_sdio_linux_remove_irq() always after calling
+	* uf_stop_thread() to kill this thread.
+	*/
+
+	unifi_trace(priv, UDBG2, "bh_thread exiting....\n");
+	return 0;
 } /* bh_thread_function() */
 
 
@@ -319,33 +324,33 @@ static int bh_thread_function(void *arg)
  *      0 on success or else a Linux error code.
  * ---------------------------------------------------------------------------
  */
-    int
+int
 uf_init_bh(unifi_priv_t *priv)
 {
-    int r;
+	int r;
 
-    /* Enable mlme interface. */
-    priv->io_aborted = 0;
+	/* Enable mlme interface. */
+	priv->io_aborted = 0;
 
 
-    /* Start the BH thread */
-    r = uf_start_thread(priv, &priv->bh_thread, bh_thread_function);
-    if (r) {
-        unifi_error(priv,
-                "uf_init_bh: failed to start the BH thread.\n");
-        return r;
-    }
+	/* Start the BH thread */
+	r = uf_start_thread(priv, &priv->bh_thread, bh_thread_function);
+	if (r) {
+		unifi_error(priv,
+			"uf_init_bh: failed to start the BH thread.\n");
+		return r;
+	}
 
-    /* Allow interrupts */
-    r = csr_sdio_linux_install_irq(priv->sdio);
-    if (r) {
-        unifi_error(priv,
-                "uf_init_bh: failed to install the IRQ.\n");
+	/* Allow interrupts */
+	r = csr_sdio_linux_install_irq(priv->sdio);
+	if (r) {
+		unifi_error(priv,
+			"uf_init_bh: failed to install the IRQ.\n");
 
-        uf_stop_thread(priv, &priv->bh_thread);
-    }
+		uf_stop_thread(priv, &priv->bh_thread);
+	}
 
-    return r;
+	return r;
 } /* uf_init_bh() */
 
 
@@ -370,28 +375,30 @@ uf_init_bh(unifi_priv_t *priv)
  */
 CsrResult unifi_run_bh(void *ospriv)
 {
-    unifi_priv_t *priv = ospriv;
-
-    /*
-     * If an error has occurred, we discard silently all messages from the bh
-     * until the error has been processed and the unifi has been reinitialised.
-     */
-    if (priv->bh_thread.block_thread == 1) {
-        unifi_trace(priv, UDBG3, "unifi_run_bh: discard message.\n");
-        /*
-         * Do not try to acknowledge a pending interrupt here.
-         * This function is called by unifi_send_signal() which in turn can be
-         * running in an atomic or 'disabled irq' level if a signal is sent
-         * from a workqueue task (i.e multicass addresses set).
-         * We can not hold the SDIO lock because it might sleep.
-         */
-        return CSR_RESULT_FAILURE;
-    }
-
-    priv->bh_thread.wakeup_flag = 1;
-    /* wake up I/O thread */
-    wake_up_interruptible(&priv->bh_thread.wakeup_q);
-
-    return CSR_RESULT_SUCCESS;
+	unifi_priv_t *priv = ospriv;
+
+	/*
+	* If an error has occurred, we discard silently all messages from the bh
+	* until the error has been processed and the unifi has been
+	* reinitialised.
+	*/
+	if (priv->bh_thread.block_thread == 1) {
+		unifi_trace(priv, UDBG3, "unifi_run_bh: discard message.\n");
+		/*
+		* Do not try to acknowledge a pending interrupt here.
+		* This function is called by unifi_send_signal()
+		* which in turn can be running in an atomic or 'disabled irq'
+		* level if a signal is sent from a workqueue task
+		* (i.e multicass addresses set). We can not hold the SDIO lock
+		* because it might sleep.
+		*/
+		return CSR_RESULT_FAILURE;
+	}
+
+	priv->bh_thread.wakeup_flag = 1;
+	/* wake up I/O thread */
+	wake_up_interruptible(&priv->bh_thread.wakeup_q);
+
+	return CSR_RESULT_SUCCESS;
 } /* unifi_run_bh() */
 
-- 
1.7.1

