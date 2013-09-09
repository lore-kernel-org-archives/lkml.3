Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3IIQnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:43:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58528 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab3IIQnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:43:10 -0400
Message-ID: <522DFA93.50308@zytor.com>
Date: Mon, 09 Sep 2013 09:42:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/12] Add BSD-style securelevel support
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>  <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>  <522DF6DC.1050303@zytor.com> <1378744207.17982.3.camel@x230.lan>
In-Reply-To: <1378744207.17982.3.camel@x230.lan>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 09:30 AM, Matthew Garrett wrote:
> On Mon, 2013-09-09 at 09:27 -0700, H. Peter Anvin wrote:
> 
>> This will break or have to be redefined once you have signed kexec.
> 
> Yeah. I wasn't really sure how to define it based on an implementation
> that isn't there yet - saying "kexec_load() of untrusted binaries"
> implies that there's some way to do it for trusted binaries.
> 

However, this is the fundamental problem with securelevel: it assumes
there is not only a strict ordering between things to be secured, but
also that specific rings will remain the meaningful levels forever.

Neither of this tend to be true long time... which leads one back to
capabilities.

	-hpa

