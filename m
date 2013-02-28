Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740Ab3B1Vxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:53:31 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33963 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab3B1Vx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:53:28 -0500
Message-ID: <512FD1D5.3010106@mit.edu>
Date: Thu, 28 Feb 2013 13:53:25 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Pavel Shilovsky <piastry@etersoft.ru>
CC: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        wine-devel@winehq.org
Subject: Re: [PATCH v3 0/7] Add O_DENY* support for VFS and CIFS/NFS
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
In-Reply-To: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[possible resend -- sorry]

On 02/28/2013 07:25 AM, Pavel Shilovsky wrote:
> This patchset adds support of O_DENY* flags for Linux fs layer. These flags can be used by any application that needs share reservations to organize a file access. VFS already has some sort of this capability - now it's done through flock/LOCK_MAND mechanis, but that approach is non-atomic. This patchset build new capabilities on top of the existing one but doesn't bring any changes into the flock call semantic.
> 
> These flags can be used by NFS (built-in-kernel) and CIFS (Samba) servers and Wine applications through VFS (for local filesystems) or CIFS/NFS modules. This will help when e.g. Samba and NFS server share the same directory for Windows and Linux users or Wine applications use Samba/NFS share to access the same data from different clients.
> 
> According to the previous discussions the most problematic question is how to prevent situations like DoS attacks where e.g /lib/liba.so file can be open with DENYREAD, or smth like this. That's why one extra flag O_DENYMAND is added. It indicates to underlying layer that an application want to use O_DENY* flags semantic. It allows us not affect native Linux applications (that don't use O_DENYMAND flag) - so, these flags (and the semantic of open syscall that they bring) are used only for those applications that really want it proccessed that way.
> 
> So, we have four new flags:
> O_DENYREAD - to prevent other opens with read access,
> O_DENYWRITE - to prevent other opens with write access,
> O_DENYDELETE - to prevent delete operations (this flag is not implemented in VFS and NFS part and only suitable for CIFS module),
> O_DENYMAND - to switch on/off three flags above.

O_DENYMAND doesn't deny anything.  Would a name like O_RESPECT_DENY be
better?

Other than that, this seems like a sensible mechanism.

--Andy

