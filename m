Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3J1Oh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:37:58 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42626 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3J1Oh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <20131016113632.6548d399@tlielax.poochiereds.net>
References: <1381936190-67628-1-git-send-email-timg@tpi.com>
	<20131016113632.6548d399@tlielax.poochiereds.net>
Date: Mon, 28 Oct 2013 09:37:56 -0500
Message-ID: <CAH2r5mvhUWAz3s3QFdK_6vjB_+fhWqSJysU_RDEETbQ0pOnwcw@mail.gmail.com>
Subject: Re: [PATCH 1/2 linux-next] cifs: Remove redundant multiplex
 identifier check from check_smb_hdr()
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Tim Gardner <timg@tpi.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, Oct 16, 2013 at 10:36 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Wed, 16 Oct 2013 09:09:49 -0600
> Tim Gardner <timg@tpi.com> wrote:
>
>> The only call site for check_smb_header() assigns 'mid' from the SMB
>> packet, which is then checked again in check_smb_header(). This seems
>> like redundant redundancy.
>>
>> Cc: Steve French <sfrench@samba.org>
>> Signed-off-by: Tim Gardner <timg@tpi.com>
>> ---
>>  fs/cifs/misc.c |   12 ++----------
>>  1 file changed, 2 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index 138a011..298e31e 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -278,7 +278,7 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
>>  }
>>
>>  static int
>> -check_smb_hdr(struct smb_hdr *smb, __u16 mid)
>> +check_smb_hdr(struct smb_hdr *smb)
>>  {
>>       /* does it have the right SMB "signature" ? */
>>       if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
>> @@ -287,13 +287,6 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
>>               return 1;
>>       }
>>
>> -     /* Make sure that message ids match */
>> -     if (mid != smb->Mid) {
>> -             cifs_dbg(VFS, "Mids do not match. received=%u expected=%u\n",
>> -                      smb->Mid, mid);
>> -             return 1;
>> -     }
>> -
>>       /* if it's a response then accept */
>>       if (smb->Flags & SMBFLG_RESPONSE)
>>               return 0;
>> @@ -310,7 +303,6 @@ int
>>  checkSMB(char *buf, unsigned int total_read)
>>  {
>>       struct smb_hdr *smb = (struct smb_hdr *)buf;
>> -     __u16 mid = smb->Mid;
>>       __u32 rfclen = be32_to_cpu(smb->smb_buf_length);
>>       __u32 clc_len;  /* calculated length */
>>       cifs_dbg(FYI, "checkSMB Length: 0x%x, smb_buf_length: 0x%x\n",
>> @@ -348,7 +340,7 @@ checkSMB(char *buf, unsigned int total_read)
>>       }
>>
>>       /* otherwise, there is enough to get to the BCC */
>> -     if (check_smb_hdr(smb, mid))
>> +     if (check_smb_hdr(smb))
>>               return -EIO;
>>       clc_len = smbCalcSize(smb);
>>
>
> Nice...
>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>



-- 
Thanks,

Steve
