Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3LQTbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:31:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab3LQTbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:31:41 -0500
Message-ID: <52B0A697.7040009@redhat.com>
Date: Tue, 17 Dec 2013 14:31:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
In-Reply-To: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 02:03 PM, Rafael Aquini wrote:
> After the locking semantics for the SysV IPC API got improved, a couple of
> IPC_RMID race windows were opened because we ended up dropping the
> 'kern_ipc_perm.deleted' check performed way down in ipc_lock().
> The spotted races got sorted out by re-introducing the old test within
> the racy critical sections.
> 
> This patch introduces ipc_valid_object() to consolidate the way we cope with
> IPC_RMID races by using the same abstraction across the API implementation.
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
