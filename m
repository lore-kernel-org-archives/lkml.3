Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3JNPio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab3JNPim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:38:42 -0400
Date: Mon, 14 Oct 2013 11:38:38 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: Re: [PATCH 3.12-rc4] cifs: ntstatus_to_dos_map[] is not terminated
Message-ID: <20131014113838.4feb90f5@tlielax.poochiereds.net>
In-Reply-To: <1381692543-41226-1-git-send-email-tim.gardner@canonical.com>
References: <1381692543-41226-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Oct 2013 13:29:03 -0600
Tim Gardner <tim.gardner@canonical.com> wrote:

> Functions that walk the ntstatus_to_dos_map[] array could
> run off the end. For example, ntstatus_to_dos() loops
> while ntstatus_to_dos_map[].ntstatus is not 0. Granted,
> this is mostly theoretical, but could be used as a DOS attack
> if the error code in the SMB header is bogus.
> 
> Cc: Steve French <sfrench@samba.org>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/cifs/netmisc.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index af847e1..651a527 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -780,7 +780,9 @@ static const struct {
>  	ERRDOS, ERRnoaccess, 0xc0000290}, {
>  	ERRDOS, ERRbadfunc, 0xc000029c}, {
>  	ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
> -	ERRDOS, ERRinvlevel, 0x007c0001}, };
> +	ERRDOS, ERRinvlevel, 0x007c0001}, {
> +	0, 0, 0 }
> +};
>  
>  /*****************************************************************************
>   Print an error message from the status code

Nice catch.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
