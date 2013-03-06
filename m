Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3CFLQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:16:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:26873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab3CFLQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:16:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,794,1355126400"; 
   d="scan'208";a="272093318"
Message-ID: <513725A8.8090904@linux.intel.com>
Date: Wed, 06 Mar 2013 03:16:56 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp> <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp> <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp> <51367104.5050200@linux.vnet.ibm.com> <20130305224432.GD27022@pd.tnic> <51368C45.40303@linux.vnet.ibm.com> <201303061016.r26AGkVV038627@www262.sakura.ne.jp>
In-Reply-To: <201303061016.r26AGkVV038627@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 02:16 AM, Tetsuo Handa wrote:
> 
> But I found that this bug occurs only when the system has little RAM.
> 
> With 892MB RAM where /proc/meminfo would show HighTotal > 0,
> this bug does not occur.
> 
>     HighTotal:          4040 kB
>     LowTotal:         873960 kB
> 
> With 888MB RAM where /proc/meminfo would show HighTotal == 0,
> this bug occurs.
> 

OK, this makes sense.  I guess we have a bug in the case where we do not
exhaust lowmem.

	-hpa


