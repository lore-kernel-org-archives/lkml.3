Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaFOQ5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:57:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40680 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaFOQ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:57:51 -0400
Message-ID: <539DD04F.9020507@zytor.com>
Date: Sun, 15 Jun 2014 09:56:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/13] kexec-bzImage: Support for loading bzImage using
 64bit entry
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com> <1401800822-27425-12-git-send-email-vgoyal@redhat.com> <20140615163515.GA17016@pd.tnic>
In-Reply-To: <20140615163515.GA17016@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 09:35 AM, Borislav Petkov wrote:
> 
>> +	if (memcmp((char *)&header->header, "HdrS", 4) != 0) {
> 
> Not strncmp? "HdrS" is a string...
> 

No, memcmp() is more appropriate.  It is really more of a byte sequence
than a string.

It could just as easily be done as:

	header->header == 0x53726448

	-hpa

