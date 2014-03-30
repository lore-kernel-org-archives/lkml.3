Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaC3HtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 03:49:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:2068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaC3HtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 03:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,759,1389772800"; 
   d="scan'208";a="502412853"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Monam Agarwal <monamagarwal123@gmail.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "eliad@wizery.com" <eliad@wizery.com>,
        "Lifshitz, Eytan" <eytan.lifshitz@intel.com>,
        "eyal@wizery.com" <eyal@wizery.com>,
        "Stepanov, Max" <Max.Stepanov@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drivers/net/wireless: Use RCU_INIT_POINTER(x, NULL) in
 iwlwifi/mvm/sta.c
Thread-Topic: [PATCH] drivers/net/wireless: Use RCU_INIT_POINTER(x, NULL) in
 iwlwifi/mvm/sta.c
Thread-Index: AQHPRsb1Ft+w9jln4k2cAk6aJZfk7Zr5S2Bg
Date: Sun, 30 Mar 2014 07:49:17 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303DBDB42@HASMSX103.ger.corp.intel.com>
References: <1395599756-7861-1-git-send-email-monamagarwal123@gmail.com>
In-Reply-To: <1395599756-7861-1-git-send-email-monamagarwal123@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,
> NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure
> is carried out before storing a pointer to that structure.
> And in the case of the NULL pointer, there is no structure to initialize.
> So, rcu_assign_pointer(p, NULL) can be safely converted to
> RCU_INIT_POINTER(p, NULL)
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> ---
>  drivers/net/wireless/iwlwifi/mvm/sta.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Applied - with small change in commit log.
Thank you for your contribution.

