Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaDYWxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:53:38 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36185 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaDYWxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1404251547020.6936@chino.kir.corp.google.com>
References: <1398437960.2159.4.camel@dabdike.int.hansenpartnership.com>
	<alpine.DEB.2.02.1404251547020.6936@chino.kir.corp.google.com>
Date: Fri, 25 Apr 2014 15:53:35 -0700
X-Google-Sender-Auth: BICbUydBQopvlG7Xdbunjf6Nd5Y
Message-ID: <CA+55aFwtF=PSrixQg7+=bhmB_6hDheykBpU2pYMGE6+zNQz=Sg@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 3.15-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 3:49 PM, David Rientjes <rientjes@google.com> wrote:
>
> Hmm, I see why this is needed because of the scsi_put_command(cmd), but I
> think you need to do struct scsi_device *sdev = ACCESS_ONCE(cmd->device)
> instead to prevent gcc from messing with the code generation.

No, if gcc were to move the access to 'cmd' to after the
'scsi_put_command(cmd)', that would be a major compiler bug.

Compilers can't just randomly move code around, guys.

            Linus
