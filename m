Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbbATSji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:39:38 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:46709 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbbATSjg (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Tue, 20 Jan 2015 13:39:36 -0500
Message-ID: <54BEA0E0.9080807@symas.com>
Date: Tue, 20 Jan 2015 18:39:28 +0000
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0 SeaMonkey/2.34a1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com> <54BCFC94.1040605@symas.com> <54BD1B53.9030901@hurleysoftware.com> <54BD328F.9090208@symas.com> <54BD567C.8070200@hurleysoftware.com> <54BD5E54.3050909@symas.com> <54BE9840.8080808@hurleysoftware.com>
In-Reply-To: <54BE9840.8080808@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:
> On 01/19/2015 02:43 PM, Howard Chu wrote:
>> The fact that EXTPROC can be manually unset is by design. Quoting from the original again:
>>
>>> stty.diff:
>>>      This file contains the changes needed for the stty(1) program
>>>      to report on the current status of the TS_EXTPROC bit.  It also
>>>      allows the user to turn on/off the TS_EXTPROC bit.  This is useful
>>>      because it allows the user to say "stty -extproc", and the
>>>      LINEMODE option will be automatically disabled, and saying "stty
>>>      extproc" will re-enable the LINEMODE option.
>
> This option is not supported by gnu coreutils.

OK. It's in *BSD and Minix. Looks like I never wrote a patch for 
coreutils for this last time around.
>
> So it's really back to the question of, does allowing EXTPROC for regular
> ttys have _value_?

Does preventing it have value? I like having the option of turning 
linemode on and off in a session, for debugging purposes if nothing else.
>
>
>>>>>>> 6. EXTPROC still does some input processing on the server. For example,
>>>>>>>        7-bit mode (ISTRIP), tolower mode (IUCLC) and processing while
>>>>>>>        closing; if input processing is being done on the local/client side,
>>>>>>>        why the extra work here?
>>>>>>
>>>>>> That's defensive, on the assumption that something else might break if e.g. the tty expected only 7-bit input but 8-bit characters were sent to it.
>>>>>
>>>>> Ok, is that because RFC 1116 doesn't specify ISTRIP and IUCLC handling so
>>>>> the server can't be sure the client did it? If so, that should be documented
>>>>> so that refactors don't remove that handling.
>>>
>>> Could you get back to me about this, as well?
>>
>> The telnet protocol (RFC854) defines a Network Virtual Terminal (NVT) as using 7-bit USASCII in an 8-bit field. As such, it expects the client to be able to generate both upper and lower case itself, so there's no analogue to IUCLC, and there would be no reason to use ISTRIP.
>>
>> RFC5198 updates the protocols to use UTF8. So again, it assumes full octets are being transmitted.
>>
>> Perhaps we can drop these special cases from the driver.
>
> I don't mind leaving it in, but without comments it looks like a
> refactoring error.

I'm working up revisions for the patch.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
