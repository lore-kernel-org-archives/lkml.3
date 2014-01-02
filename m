Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaABU5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:57:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbaABU5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:57:52 -0500
Message-ID: <52C5D28F.6030008@zytor.com>
Date: Thu, 02 Jan 2014 12:56:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Torsten Duwe <duwe@lst.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
References: <20131121191907.GA26366@srcf.ucam.org> <20131122185706.GK4046@redhat.com> <87vbzju6ql.fsf@xmission.com> <20131125163920.GC23094@redhat.com> <87fvqj2vxz.fsf@xmission.com> <20131126142759.GA5473@redhat.com> <20131219125439.GA6379@lst.de> <20131220141917.GB27063@redhat.com> <87a9fvqfs4.fsf@xmission.com> <CAGXu5jKJ88J-++nvkPVvghkXbN+_mB=T1siSDF7yoXQ-d-ONxg@mail.gmail.com> <20140102203912.GB22822@redhat.com>
In-Reply-To: <20140102203912.GB22822@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 12:39 PM, Vivek Goyal wrote:
> 
> If secureboot is enabled, it enforces module signature verification. I 
> think similar will happen for kexec too. How would kernel know that on
> a secureboot platform fd original verification will happen and it is
> sufficient.
> 
> I personally want to support bzImage as well (apart from ELF) because
> distributions has been shipping bzImage for a long time and I don't
> want to enforce a change there because of secureboot. It is not necessary.
> Right now I am thinking more about storing detached bzImage signatures
> and passing those signatures to kexec system call.
> 

Since the secureboot scenario probably means people will be signing
those kernels, and those kernels are going to be EFI images, that in
order to have "one kernel, one signature" there will be a desire to
support signed PE images.  Yes, PE is ugly but it shouldn't be too bad.
 However, it is probably one of those things that can be dealt with one
bit at a time.

	-hpa


