Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161917Ab3DEPcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 11:32:31 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:10135
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755627Ab3DEPca convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:32:30 -0400
X-Forefront-Antispam-Report: CIP:132.245.1.149;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0512HT003.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: PS1(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah1954cbh8275bhz32i2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1155h)
From: Scan Subscription <scan-subscription@coverity.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: New Defect(s) reported by Coverity Scan 
Thread-Topic: New Defect(s) reported by Coverity Scan 
Thread-Index: Ac4yEmGCRltLC7mIQ8Wgr1X8pWsCtQ==
Date: Fri, 5 Apr 2013 15:32:25 +0000
Message-ID: <C0A4ACBB26D853488EA0C68388B702682F97EAC1@BLUPRD0512MB628.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.23.129.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: coverity.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Please find the latest report on new defect(s) that have been introduced to the Linux Kernel found with Coverity SCAN. 


Defect(s) Reported-by: Coverity Scan:
___________________________________________________________________________
** CID 996157: Logically dead code (DEADCODE)
/net/mac80211/sta_info.c: 808
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=996157

###########################################################################
Defect Details:
___________________________________________________________________________
CID 996157: Logically dead code (DEADCODE)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=996157

/net/mac80211/sta_info.c: 803 ( assignment)

   797     for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
   798                __ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]));
>>> Assigning: "have_key" = "true".
   799                have_key = true;
   800    	}
   801    	if (sta->ptk) {
   802    		__ieee80211_key_free(key_mtx_dereference(local, sta->ptk));
>>> Assigning: "have_key" = "true".
   803    		have_key = true;
   804    	}
   805    	mutex_unlock(&local->key_mtx);
   806    

>>> At condition "have_key", the value of "have_key" must be equal to 1.
>>> The condition "!have_key" cannot be true.

   807    	if (!have_key)
>>> CID 996157: Logically dead code (DEADCODE) Execution cannot reach 
>>> this statement "synchronize_net();".
   808    		synchronize_net();
   809    
   810    	sta->dead = true;
   811    
  
  

  
________________________________________________________________________


To view the defects in Coverity Scan visit, http://scan5.coverity.com:8080.  
If you don't have a username, you can register at http://scan.coverity.com/
	
Thank you,
Dakshesh Vyas
Coverity SCAN-ADMIN
scan-admin at coverity.com
http://scan.coverity.com

