Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaJMPTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:19:36 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:58841 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302AbaJMPTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:19:34 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2014 11:19:33 EDT
X-RRZE-Submit-IP: 131.188.11.52
Message-ID: <72dd38ce80e5b71673cb4ee20149ccb2.squirrel@faumail.uni-erlangen.de>
Date: Mon, 13 Oct 2014 17:10:41 +0200
Subject: [ANNOUNCE] undertaker 1.6
From: stefan.hengelein@fau.de
To: linux-kernel@vger.kernel.org
Cc: cados-dev@lists.cs.fau.de
User-Agent: SquirrelMail/1.4.23 [SVN]
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CADOS team is pleased to announce the release of the undertaker tool
version 1.6. The tool is a result of the VAMOS[1] and CADOS[2] research
projects and
available for download at https://vamos.informatik.uni-erlangen.de/files/

Please visit our project site at:
https://undertaker.cs.fau.de


= What is undertaker? =

The undertaker is a tool for static code analysis for code with C
preprocessor directives, which can be used in various modes. The most
prominent one checks every single preprocessor block within the file
whether it can be selected or deselected, which in many cases is a great
asset for code maintenance.
Some preprocessor blocks are only seemingly conditional. In many cases, it
turns out that additional constraints from the project's
configuration model causes such conditional blocks to be in fact
unconditionally selected or unselected. We call such block "dead" and
"undead" conditional blocks or more general, a defect.

Undertaker provides tools to extract the configuration model from the
Linux configuration tooling Kconfig and to perform this check on whole
source trees.

Please see https://undertaker.cs.fau.de for a quick tour.


= What undertaker is not? =

It isn't an automatic patch generator. Because of peculiarities in the
Kconfig semantics, (ignored) coding guidelines and simply engineering
issues, some defects are not caught by the undertaker. Note that our
philosophy is that we prefer false negatives over false positives, i.e.,
we prefer to miss reports than reports that are no issue at all.

= What is new in undertaker 1.6 =

 * New tool: undertaker-checkpatch: checks patch files for defects and
helps to analyze them

 * New tool: flipper: provides a lean method for kernel tracing as
extension for the tailor

 * undertaker: now has a new mode `-u` to minimize defect formulas (thanks
to the PicoMUS-Tool, which is part of PicoSAT)

 * Further improvements in performance and bug fixes in our tools

= What is golem =

Golem is a tool for build system analysis. It exploits the "dancing
makefiles" pattern found in Kbuild to induce dependency constraints from
build rules. The resulting inferences significantly improve the results of
undertaker. The tool `undertaker-kconfigdump` has learned the option `-i`
to automatically add inferences to the models.

A basic primitive of golem is to learn what files would get compiled with
the current configuration. This is accessibly with `golem -l`.

= What is vampyr =

Vampyr is a configurability-aware driver for static-analysis (compile
testing) on a single file or a list of files (batchmode `-b`).

With the `-C` option it is possible to run static analysis with a compiler
like gcc / clang or the sparse tool.

A complete analysis of the variability can be done with the `-a` directive
and additionally the coverage strategy can be chosen with `vampyr -A
{simple, min, simple_decision, min_decision}`

= What is undertaker-checkpatch =

This new tool analyzes patch files and accordingly reports changes to
defects such as newly introduced or fixed defects. Defects can also be
correlated to changes in Kconfig and vice versa.

Additionally, undertaker-checkpatch ships the functionality to further
analyze the causes of defects, displaying contradictory Kconfig items, a
block's precondition or the defect causing formula.

= What is undertaker-tailor =

If the intended use of a system is known at kernel compilation time, an
effective approach to reduce the kernel's attack surface is to conﬁgure
the kernel to not compile unneeded functionality.
However, finding a fitting conﬁguration requires extensive technical
expertise about currently more than 14.000 Linux conﬁguration options, and
needs to be repeated at each kernel update.
Therefore, maintaining such a custom-conﬁgured kernel entails considerable
maintenance and engineering costs.

undertaker-tailor[3] automatically determines a kernel conﬁguration that
enables only kernel functionalities that are actually necessary in a given
scenario. The approach exhibits promising security improvements by simply
not compiling unnecessary files and code.

With the release of version 1.6, undertaker-tailor received a new tool
called flipper[4]. While ftrace was employed for kernel function tracing
earlier, its usage caused quite a lot of overhead during the observation
of the kernel. Flipper however relies on small bit-setting instructions
patched into the kernel to collect tracing data and delivers more accurate
results with less run time overhead.

= Links =

[1] https://vamos.cs.fau.de

[2] https://cados.cs.fau.de

[3] http://vamos.cs.fau.de/trac/undertaker/wiki/UndertakerTailor

[4] http://vamos.cs.fau.de/trac/undertaker/wiki/UndertakerTailorFlipper


= CADOS at the Linux Plumbers Conference http://www.linuxplumbersconf.org =

There will be two talks at the 'development tools' microconference at the
Linux Plumbers Conference.
Valentin Rothberg will show the functionality of the new
undertaker-checkpatch tool (
http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 ).

Stefan Hengelein will explain the vampyr tool for configurability-aware
compile testing of source code (
http://www.linuxplumbersconf.org/2014/ocw/sessions/2313 ).



