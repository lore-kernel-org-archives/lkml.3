Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbbAMW0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:26:44 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65277 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbAMW0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:26:42 -0500
Message-ID: <54B59B9E.4000806@nod.at>
Date: Tue, 13 Jan 2015 23:26:38 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: user-mode-linux-devel@lists.sourceforge.net, dxld@darkboxed.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hostfs: Use noop_fsync for directories
References: <1421187358-32600-1-git-send-email-richard@nod.at> <20150113221958.GA27739@infradead.org>
In-Reply-To: <20150113221958.GA27739@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.01.2015 um 23:19 schrieb Christoph Hellwig:
> On Tue, Jan 13, 2015 at 11:15:58PM +0100, Richard Weinberger wrote:
>> Daniel reported that dpkg(1) dies if the root filesystem is a hostfs
>> because it does not expect fsync(2) to fail with EINVAL on directories.
>> While fsync(2) is allowed to fail with EINVAL if the filesystem does not
>> support it we can do better and use noop_fsync() to not confuse userspace
>> further.
> 
> Shouldn't hostfs pass the fsync through to the host filesystem?

hostfs tries do reduce the amount of syscall between guest and host as much
as possible. For file operations it passes everything down to the host but
for directory operations only ->iterate() does.

It is already horrible slow, if we add an ->open() for directory too it would
get even more slower. :-(

Thanks,
//richard
