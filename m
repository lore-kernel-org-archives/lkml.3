Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3LQUlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:41:50 -0500
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51795 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3LQUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:41:48 -0500
From: Greg Thelen <gthelen@google.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] ipc: introduce ipc_valid_object() helper to sort out IPC_RMID races
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
Date: Tue, 17 Dec 2013 12:41:46 -0800
Message-ID: <xr93vbynjjlh.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.130007 (Ma Gnus v0.7) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17 2013, Rafael Aquini wrote:

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

Acked-by: Greg Thelen <gthelen@google.com>
