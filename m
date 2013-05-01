Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3EARgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:36:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46187 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab3EARgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:36:12 -0400
Message-ID: <5181527A.8080904@zytor.com>
Date: Wed, 01 May 2013 10:35:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andrew Lutomirski <luto@mit.edu>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't already
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net> <20130501113352.GA29571@pd.tnic> <20130501163404.GA6286@thunk.org> <518145F6.3060800@zytor.com> <20130501172030.GA8609@thunk.org>
In-Reply-To: <20130501172030.GA8609@thunk.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 10:20 AM, Theodore Ts'o wrote:
> On Wed, May 01, 2013 at 09:42:30AM -0700, H. Peter Anvin wrote:
>> The erratum reads seriously, but it only affects crossings between pages
>> of different page types, which is rare in itself.  WT and WP are not
>> even used in Linux; the UC case we end up doing 8-byte stores instead of
>> the proper size, which is wrong, but for the case where the user is
>> malicious the user could just do that directly, and it seems extremely
>> hard to envision a scenario where someone would do that intentionally.
> 
> Yeah, I wasn't so much worried about a malicious user as much as a
> situation where the you're trying to debug a mysterious and
> hard-to-reproduce failure, start tearing your hair out, and wondering
> whether you're going insane or the compiler hates you and is out to
> get you and you start staring at assembly code to try to figure out
> how some piece of memory got mysteriously corrupted....
> 

If you are crossing pages with different memory types, the fact that the
sizes being written are wrong is probably the least of your problems.

	-hpa


