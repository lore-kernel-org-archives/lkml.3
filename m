Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3KMBDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:03:22 -0500
Received: from mail.tpi.com ([74.45.170.26]:43311 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab3KMBDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:03:14 -0500
Message-ID: <5282CFCF.2020100@canonical.com>
Date: Tue, 12 Nov 2013 17:03:11 -0800
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
CC: linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: Re: [PATCH linux-next] cifs: Use data structures to compute NTLMv2
 response offsets
References: <1383867657-110399-1-git-send-email-tim.gardner@canonical.com> <CADT32e+ed9EzAb2jraHxmB0CF5AMUQ7XYiuEfH-FOcy7XqqmNQ@mail.gmail.com>
In-Reply-To: <CADT32e+ed9EzAb2jraHxmB0CF5AMUQ7XYiuEfH-FOcy7XqqmNQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 01:19 PM, Shirish Pargaonkar wrote:
> Looks correct.  You may want to verify that the code works fine for both
> sec=ntlmssp/ntlmsspi and sec=ntlmv2/ntlmv2i mount options.
> 
> Reviewed-by: Shirish Pargaonkar <spargaonkar@suse.com>
> 

These are the mount attempt results using a stock 3.12 kernel built with
the Ubuntu Trusty config. I am not well versed enough in the various
security mechanisms to know what should work.

mount sec=ntlmssp on WinPro8 success
mount sec=ntlmsspi on WinPro8 failure
mount sec=ntlmv2 on WinPro8 failure
mount sec=ntlmv2i on WinPro8 failure
mount sec=ntlmssp on iOS-10.8 success
mount sec=ntlmsspi on iOS-10.8 success
mount sec=ntlmv2 on iOS-10.8 failure
mount sec=ntlmv2i on iOS-10.8 failure
mount sec=ntlmssp on Linux-3.2 success
mount sec=ntlmsspi on Linux-3.2 failure
mount sec=ntlmv2 on Linux-3.2 success
mount sec=ntlmv2i on Linux-3.2 failure

The mount parameters used were '-o
noserverino,nounix,user=test,pass=test'. For example,

sudo mount -t cifs //10.0.0.182/test /tmp/mnt -o
noserverino,nounix,user=test,pass=test,sec=ntlmssp

The patched kernel produced identical results.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
