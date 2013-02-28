Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3B1BFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:05:05 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:57407 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3B1BFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:05:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302271613210.27317@chino.kir.corp.google.com>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
	<1361945258-24420-2-git-send-email-john.stultz@linaro.org>
	<alpine.DEB.2.02.1302271417000.7155@chino.kir.corp.google.com>
	<CAMP5XgcjdZk5MZ9v+W5phgWgE4Q0Pc_2FfopapjctsV6sdguLQ@mail.gmail.com>
	<alpine.DEB.2.02.1302271509230.24485@chino.kir.corp.google.com>
	<CAMP5XgemB4AdKEY4HFLwupo1CGv89hbmB+HUYYN8qdQRYCTdHg@mail.gmail.com>
	<alpine.DEB.2.02.1302271613210.27317@chino.kir.corp.google.com>
Date: Wed, 27 Feb 2013 17:05:01 -0800
Message-ID: <CAMP5XgdE-Ui9qiLGjvAXk13LbCzn-bHEC_AsxQ8dWpz+R-qSDg@mail.gmail.com>
Subject: Re: [PATCH 1/5] staging: android: lowmemorykiller: Add config option
 to support oom_adj values
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: David Rientjes <rientjes@google.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 4:14 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 27 Feb 2013, Arve Hjønnevåg wrote:
>
>> Because, without this patch, the values written to
>> /sys/module/lowmemorykiller/parameters/adj do not get adjusted and
>> therefore do not match the correct processes.
>>
>
> Explain how this can possibly be consistent if your system includes two
> processes, one writing oom_adj values and one writing oom_score_adj
> values, and the kernel has this new option enabled?

These values are all written by the same process. If you want to
improve this, the lowmemorykiller will need a separate score_adj
parameter so that it knows for sure which type of value it receives.
You changed the meaning of /sys/module/lowmemorykiller/parameters/adj.
This patch restores the old behavior as long as the values you write
are within the range oom_adj, while still supporting the new behavior
you added in the likely case that one of the values are out of range
for oom_adj.

-- 
Arve Hjønnevåg
