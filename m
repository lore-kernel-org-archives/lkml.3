Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbbATMYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:24:44 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:48844 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbATMYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:24:42 -0500
MIME-Version: 1.0
In-Reply-To: <20150120121100.28406.95201.stgit@localhost.localdomain>
References: <20150120121100.28406.95201.stgit@localhost.localdomain>
Date: Tue, 20 Jan 2015 13:24:41 +0100
X-Google-Sender-Auth: 1YMNKiyc1uqpylqAlrG_pcQNrNw
Message-ID: <CAMuHMdW9MDTMZEN7paytQm+7-6sY_qTHOWQ9KY0ooaggyU8n=w@mail.gmail.com>
Subject: Re: [PATCH RESEND] um,ethertap: use strncpy
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 1:11 PM, Alan <gnomes@lxorguk.ukuu.org.uk> wrote:
> I can't prove the case pointed out in
> https://bugzilla.kernel.org/show_bug.cgi?id=82341
> is correct so let us play safe.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  arch/um/os-Linux/drivers/ethertap_user.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
> index b39b669..6d49182 100644
> --- a/arch/um/os-Linux/drivers/ethertap_user.c
> +++ b/arch/um/os-Linux/drivers/ethertap_user.c
> @@ -105,7 +105,7 @@ static int etap_tramp(char *dev, char *gate, int control_me,
>         sprintf(data_fd_buf, "%d", data_remote);
>         sprintf(version_buf, "%d", UML_NET_VERSION);

The two above may also overflow, if the numbers contain more than 5
resp. 6 digits.

>         if (gate != NULL) {
> -               strcpy(gate_buf, gate);
> +               strncpy(gate_buf, gate, 15);

Same comment as before:

"This will copy at most 15 bytes.
 If "gate" contains 15 or more characters, gate_buf[] won't be
 zero-terminated.
 I think you better use strlcpy(), unless the remaining of the buffer
 must be filled with zeroes."

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
