Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3CFSPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:15:55 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51580 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3CFSPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:15:54 -0500
Message-ID: <513787BB.4040504@linux.vnet.ibm.com>
Date: Wed, 06 Mar 2013 10:15:23 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: bp@alien8.de, hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp> <51367104.5050200@linux.vnet.ibm.com>	<20130305224432.GD27022@pd.tnic> <201303062358.EFG90616.HLtSQFJFOMVOFO@I-love.SAKURA.ne.jp> <5137822F.2030501@linux.vnet.ibm.com>
In-Reply-To: <5137822F.2030501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030618-5806-0000-0000-00002038459F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anybody know what this business is in __cpa_process_fault()?

>         /*
>          * Ignore the NULL PTE for kernel identity mapping, as it is expected
>          * to have holes.
>          * Also set numpages to '1' indicating that we processed cpa req for
>          * one virtual address page and its pfn. TBD: numpages can be set based
>          * on the initial value and the level returned by lookup_address().
>          */

If this is expecting the identity mapping to have holes, then the
BUG_ON() is wrong.  But how would it _get_ holes?

