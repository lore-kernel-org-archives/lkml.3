Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaJ0XKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:10:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:61070 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaJ0XKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,798,1406617200"; 
   d="scan'208";a="597258674"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Yucong <slaoub@gmail.com>, "bp@alien8.de" <bp@alien8.de>
CC: "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
Thread-Topic: [PATCH 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
Thread-Index: AQHP8YEgk/A6GJadaEm13BiNXHlqipxEke1g
Date: Mon, 27 Oct 2014 23:10:07 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32917841@ORSMSX114.amr.corp.intel.com>
References: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
 <1414371382-15491-3-git-send-email-slaoub@gmail.com>
In-Reply-To: <1414371382-15491-3-git-send-email-slaoub@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+	m->mcgstatus |= (MCG_STATUS_MCIP|MCG_STATUS_RIPV);
+	severity = mce_severity(m, mca_cfg.tolerant, NULL);

This seems a big hack to make mce_severity() work when called from
CMCI context (when MCG_STATUS register is not set).  It would also
be confusing as the subsequent logged entries would show MCIP and RIPV
bits set in the mcg_status.

If someone can think of a less hacky way to do this, that would be good. Otherwise
the code needs a comment, and should reset m->mcg_status to avoid making logs
that have incorrect data.

-Tony
