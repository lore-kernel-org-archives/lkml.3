Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaJHQpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:45:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbaJHQpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:45:03 -0400
Message-ID: <54356970.7050805@redhat.com>
Date: Wed, 08 Oct 2014 12:42:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, mingo@redhat.com,
        peterz@infradead.org
CC: linux-kernel@vger.kernel.org, tkhai@yandex.ru
Subject: Re: [PATCH] sched/fair: Care divide error in update_task_scan_period()
References: <5434DCFF.1040208@jp.fujitsu.com>
In-Reply-To: <5434DCFF.1040208@jp.fujitsu.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 02:43 AM, Yasuaki Ishimatsu wrote:

>   The divide error is rare case because the trigger is node offline.
>   By this patch, when both of private and shared are set to 0, diff
>   is just set to 0, not calculating the division.

How about a simple

    if (private + shared) == 0)
          return;

higher up in the function, to avoid adding an extra
layer of indentation and confusion to the main part
of the function?
