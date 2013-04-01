Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab3DAWfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:35:46 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:24686
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab3DAWfo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:35:44 -0400
X-Forefront-Antispam-Report: CIP:132.245.1.149;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0512HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: PS1(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah1954cbh8275bhz32i2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1155h)
From: Scan Subscription <scan-subscription@coverity.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: New Defect(s) reported by Coverity Scan 
Thread-Topic: New Defect(s) reported by Coverity Scan 
Thread-Index: Ac4vKFyOTtoAYJ3zQuCBe1mNRW6iUg==
Date: Mon, 1 Apr 2013 22:34:51 +0000
Message-ID: <C0A4ACBB26D853488EA0C68388B702682073D328@BLUPRD0512MB628.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.125.71.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: coverity.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Please find the latest report on new defect(s) that have been introduced to the Linux Kernel found with Coverity Scan. 


Defect(s) Reported-by: Coverity Scan:
___________________________________________________________________________
** CID 993740: Copy-paste error (COPY_PASTE_ERROR)
/net/l2tp/l2tp_core.c: 1780
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=993740


** CID 990693: Out-of-bounds access (OVERRUN)
/drivers/net/wireless/iwlwifi/pcie/tx.c: 1653
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=990693


** CID 990226: Structurally dead code (UNREACHABLE)
/drivers/gpu/drm/nouveau/nv50_display.c: 484
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=990226


** CID 989738: Array compared against 0 (NO_EFFECT)
/drivers/net/wireless/iwlwifi/pcie/tx.c: 1267
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=989738



** CID 989735: Unchecked return value (CHECKED_RETURN)
/drivers/net/usb/ax88179_178a.c: 1180
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=989735


** CID 989734: Unchecked return value (CHECKED_RETURN)
/drivers/net/usb/ax88179_178a.c: 388
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=989734


** CID 102438: Dereference after null check (FORWARD_NULL)
/kernel/trace/trace.c: 2436
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=102438



###########################################################################
Defect Details:
___________________________________________________________________________
CID 993740: Copy-paste error (COPY_PASTE_ERROR)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=993740

/net/l2tp/l2tp_core.c: 1774 ( original)
   1771    int l2tp_session_delete(struct l2tp_session *session)
   1772    {
   1773    	if (session->ref)
>>> "*session->ref" looks like the original copy.
   1774    		(*session->ref)(session);
   1775    	__l2tp_session_unhash(session);
   1776    	l2tp_session_queue_purge(session);
   1777    	if (session->session_close != NULL)
   1778    		(*session->session_close)(session);
   1779    	if (session->deref)
>>> CID 993740: Copy-paste error (COPY_PASTE_ERROR) "ref" in 
>>> "*session->ref" looks like a copy-paste error.  Should it say "deref" instead?
   1780    		(*session->ref)(session);
   1781    	l2tp_session_dec_refcount(session);
   1782    	return 0;
   1783    }
   1784    EXPORT_SYMBOL_GPL(l2tp_session_delete);
  
  
________________________________________________________________________
CID 990693: Out-of-bounds access (OVERRUN)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=990693

/drivers/net/wireless/iwlwifi/pcie/tx.c: 1653 ( overrun-buffer-arg)
   1650    		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
   1651    
   1652    	/* The first TB points to the scratchbuf data - min_copy bytes */
>>> CID 990693: Out-of-bounds access (OVERRUN) Overrunning struct type 
>>> iwl_cmd_header of 4 bytes by passing it to a function which accesses it at byte offset 15 using argument "16UL".
   1653    	memcpy(&txq->scratchbufs[q->write_ptr], &dev_cmd->hdr,
   1654    	       IWL_HCMD_SCRATCHBUF_SIZE);
   1655    	iwl_pcie_txq_build_tfd(trans, txq, tb0_phys,
   1656    			       IWL_HCMD_SCRATCHBUF_SIZE, 1);
   1657    
  
________________________________________________________________________
CID 990226: Structurally dead code (UNREACHABLE)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=990226

/drivers/gpu/drm/nouveau/nv50_display.c: 484 ( unreachable)
   481    	if (nouveau_bo_rd32(flip->disp->sync, flip->chan->addr / 4) ==
   482    					      flip->chan->data);
   483    		return true;
>>> CID 990226: Structurally dead code (UNREACHABLE) This code cannot be 
>>> reached: "usleep_range(1UL, 2UL);".
   484    	usleep_range(1, 2);
   485    	return false;
   486    }
   487    
   488    void
  
________________________________________________________________________
CID 989738: Array compared against 0 (NO_EFFECT)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=989738

/drivers/net/wireless/iwlwifi/pcie/tx.c: 1267 ( array_null)
   1264    	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
   1265    		int copy = 0;
   1266    
>>> CID 989738: Array compared against 0 (NO_EFFECT) Comparing an array 
>>> to null is not useful: "!cmd->len".
   1267    		if (!cmd->len)
   1268    			continue;
   1269    
   1270    		/* need at least IWL_HCMD_SCRATCHBUF_SIZE copied */
   1271    		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
  
________________________________________________________________________
CID 989735: Unchecked return value (CHECKED_RETURN)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=989735

/drivers/net/usb/ax88179_178a.c: 1180 ( check_return)
   1177    	if (((skb->len + 8) % frame_size) == 0)
   1178    		tx_hdr2 |= 0x80008000;	/* Enable padding */
   1179    
>>> CID 989735: Unchecked return value (CHECKED_RETURN) Calling function 
>>> "skb_linearize(struct sk_buff *)" without checking return value (as is done elsewhere 39 out of 45 times).
>>> No check of the return value of "skb_linearize(skb)".
   1180    	skb_linearize(skb);
   1181    	headroom = skb_headroom(skb);
   1182    	tailroom = skb_tailroom(skb);
   1183    
   1184    	if (!skb_header_cloned(skb) &&
  

________________________________________________________________________
CID 989734: Unchecked return value (CHECKED_RETURN)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=989734

/drivers/net/usb/ax88179_178a.c: 388 ( check_return)
   385    	u16 tmp16;
   386    	u8 tmp8;
   387    
>>> CID 989734: Unchecked return value (CHECKED_RETURN) Calling function 
>>> "usbnet_suspend(struct usb_interface *, pm_message_t)" without checking return value (as is done elsewhere 4 out of 5 times).
>>> No check of the return value of "usbnet_suspend(intf, message)".
   388    	usbnet_suspend(intf, message);
   389    
   390    	/* Disable RX path */
   391    	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
   392    			      2, 2, &tmp16);
  

________________________________________________________________________
CID 102438: Dereference after null check (FORWARD_NULL)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=102438

/kernel/trace/trace.c: 2431 ( var_compare_op)
   2428    	int ret;
   2429    
   2430    	if (iter->ent == NULL) {
>>> Comparing "iter->tr" to null implies that "iter->tr" might be null.
   2431    		if (iter->tr) {
   2432    			seq_printf(m, "# tracer: %s\n", iter->trace->name);
   2433    			seq_puts(m, "#\n");
   2434    			test_ftrace_alive(m);
   2435    		}
>>> CID 102438: Dereference after null check (FORWARD_NULL) Passing 
>>> "iter" to function "trace_empty(struct trace_iterator *)", which dereferences null "iter->tr".
   2436    		if (iter->snapshot && trace_empty(iter))
   2437    			print_snapshot_help(m, iter);
   2438    		else if (iter->trace && iter->trace->print_header)
   2439    			iter->trace->print_header(m);
   2440    		else
  
________________________________________________________________________


To view the defects in Coverity Scan visit, http://scan5.coverity.com:8080.  
If you don't have a username, you can register at http://scan.coverity.com/user_register.html 
	
Thank you,
Dakshesh Vyas
Coverity Scan-Admin
scan-admin at coverity.com
http://scan.coverity.com

