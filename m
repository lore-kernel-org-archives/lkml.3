Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaFJIRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:17:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbaFJIRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:17:45 -0400
Message-ID: <5396BF26.9040805@suse.cz>
Date: Tue, 10 Jun 2014 10:17:42 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz>	<1399639944-20551-4-git-send-email-mmarek@suse.cz>	<CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com>	<538EEA3D.1080105@suse.cz>	<538F1B41.3060904@suse.cz>	<20140605155614.GA18376@sepie.suse.cz> <CAMuHMdU0PQsKkYuFpxca1u7+tPbkxQsnNJ1b5-L-aJG9ZCyyEA@mail.gmail.com>
In-Reply-To: <CAMuHMdU0PQsKkYuFpxca1u7+tPbkxQsnNJ1b5-L-aJG9ZCyyEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-10 09:40, Geert Uytterhoeven wrote:
> Hi Michael,
> 
> On Thu, Jun 5, 2014 at 5:56 PM, Michal Marek <mmarek@suse.cz> wrote:
>> --- a/arch/um/Makefile
>> +++ b/arch/um/Makefile
>> @@ -111,8 +111,7 @@ endef
>>  KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
>>
>>  archheaders:
>> -       $(Q)$(MAKE) -C '$(srctree)' KBUILD_SRC= \
>> -               ARCH=$(HEADER_ARCH) O='$(objtree)' archheaders
>> +       $(Q)$(MAKE) KBUILD_SRC= ARCH=$(HEADER_ARCH) archheaders
> 
> Should the logic in https://lkml.org/lkml/2014/6/1/17 be changed as well?

I haven't tried it, but I don't see a problem with the added make
invocations:

+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.asm-generic \
+		    SRCARCH=$(HEADER_ARCH) src=asm \
+		    obj=arch/$(HEADER_ARCH)/include/generated/asm
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.asm-generic \
+		    SRCARCH=$(HEADER_ARCH) src=uapi/asm \
+		    obj=arch/$(HEADER_ARCH)/include/generated/uapi/asm

The problem with the first make was the directory change (-C ...), which
broke the relative paths. These two just spawn another make in the
current directory, so it should be fine.

Michal
