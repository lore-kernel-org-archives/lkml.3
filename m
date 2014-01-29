Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaA2Qx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:53:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35471 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaA2Qx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:53:28 -0500
From: Nick Alcock <nick.alcock@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: respect FMODE_UNSIGNED_OFFSET in p(read|write)[v]*().
References: <87ppnbf1b3.fsf@spindle.srvr.nix>
	<20140129151812.GJ10323@ZenIV.linux.org.uk>
Emacs: it's like swatting a fly with a supernova.
Date: Wed, 29 Jan 2014 16:53:22 +0000
In-Reply-To: <20140129151812.GJ10323@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 29 Jan 2014 15:18:12 +0000")
Message-ID: <87y51yenlp.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Jan 2014, Al Viro outgrape:

> On Wed, Jan 29, 2014 at 11:57:20AM +0000, Nick Alcock wrote:
>>  	ssize_t ret = -EBADF;
>>  
>> -	if (pos < 0)
>> +	f = fdget(fd);
>> +	if ((pos < 0) && (!f.file || !unsigned_offsets(f.file))) {
>> +		fdput(f);
>>  		return -EINVAL;
>> +	}
>
> ... and now pread(-1, ...) fails with EINVAL instead of EBADF.

Sorry, I don't see it. If the fh is invalid, control flow is unchanged
unless pos is also < 0 (that's an && outside the bracketed section, not
an ||, and nothing I've touched changes ret outside that conditional
branch): if pos *is* < 0, we'd have had an EINVAL before and we have one
now, likewise unchanged.

What am I missing?

(Or did you miss the brackets enclosing (!f.file || !unsigned_offsets(f.file))?
If so, I'm not surprised: it would really be easier to read if that
function had the inverse sense, 'signed_offsets()'...)

-- 
NULL && (void)
