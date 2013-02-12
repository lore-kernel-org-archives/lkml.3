Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab3BLSHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:07:51 -0500
Received: from mail.tpi.com ([70.99.223.143]:3223 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933475Ab3BLSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:07:50 -0500
Message-ID: <511A84E8.5090309@canonical.com>
Date: Tue, 12 Feb 2013 11:07:36 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH linux-next] befs: befs_fill_super(): remove unreachable
 code
References: <1360690488-60060-1-git-send-email-tim.gardner@canonical.com> <87halhfms4.fsf@xmission.com>
In-Reply-To: <87halhfms4.fsf@xmission.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 10:46 AM, Eric W. Biederman wrote:
> Tim Gardner <tim.gardner@canonical.com> writes:
> 
>> befs_sb->num_blocks is of base type u64 which is the same as sector_t.
>> Therefore, num_blocks can never be larger then the maximum
>> value of sector_t.
> 
> The analysys is wrong.  On 32bit with CONFIG_LBAF unset sector_t is an
> unsigned long aka a u32, while befs_off_t is always a u64.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Dang - you're right.

-- 
Tim Gardner tim.gardner@canonical.com
