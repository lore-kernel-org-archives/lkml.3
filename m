Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaBTSaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:30:22 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:54280 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaBTSaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:30:19 -0500
Message-ID: <1392921199.29525.0.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH v2] target_core_alua: silence GCC warning
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 20 Feb 2014 10:33:19 -0800
In-Reply-To: <1392883672.5070.21.camel@x220>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	 <1392803546.27558.16.camel@x220>
	 <CAMuHMdXZrw7oU=n60+PNNQftU6Su=mBf2V75TCO8Ws1pS5z+6Q@mail.gmail.com>
	 <1392804347.27558.20.camel@x220>
	 <1392850749.22195.1.camel@haakon3.risingtidesystems.com>
	 <1392883672.5070.21.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 09:07 +0100, Paul Bolle wrote:
> Building target_core_alua.o triggers a GCC warning:
>     drivers/target/target_core_alua.c: In function ‘target_alua_state_check’:
>     drivers/target/target_core_alua.c:773:18: warning: ‘alua_ascq’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>        cmd->scsi_ascq = alua_ascq;
>                       ^
> 
> This is a false positive. A little trial and error shows it is
> apparently caused by core_alua_state_lba_dependent(). It must be hard
> for GCC to track the branches of a switch statement, inside a
> list_for_each_entry loop, inside a while loop.
> 
> But if we add a small (inline) helper function we can reorganize the
> code a bit. That also allows to drop alua_ascq which, obviously, gets
> rid of this warning.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v2: Make core_alua_state_nonoptimized() return void, as Geert
> suggested. 
> 
> Also keep core_alua_state_lba_dependent() inline. Setting that function
> noinline was just a leftover from the trial and error fase, and isn't
> needed to make the warning go away. Ie, I was sloppy in v1!
> 
> Still compile tested only.
> 
>  drivers/target/target_core_alua.c | 95 ++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 51 deletions(-)
> 

Applied to target-pending/for-next.

Thanks Paul!

--nab

