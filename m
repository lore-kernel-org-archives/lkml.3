Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbbAIWv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:51:28 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:44733 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbbAIWv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:51:26 -0500
MIME-Version: 1.0
In-Reply-To: <54AD2C56.10700@gmail.com>
References: <54AD2C56.10700@gmail.com>
Date: Fri, 9 Jan 2015 14:51:25 -0800
Message-ID: <CALAqxLXWkrcw0-81XC_KoBcKzC2dJvJZfA0ENUJEAREePJji3A@mail.gmail.com>
Subject: Re: Request for review of adjtimex(2) man page
From: John Stultz <john.stultz@linaro.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Petr Gajdos <PGajdos@suse.cz>,
        Laurent Georget <laurent.georget@supelec.fr>,
        Richard Cochran <richardcochran@gmail.com>,
        Jeff Epler <jepler@unpythonic.net>,
        Alexander Gordeev <agordeev@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 4:53 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hello all,
>
> Recently, I made made a number of changes to the adjtimex(2)
> man page, to try and add a bit more detail, since the page
> was formerly in a very sorry state.

Yes. My apologies for some of that. Its been on my todo to try to fix
this up, but I just haven't been able to get to it.


> I would be happy if some NTP/time-knowledgeable folk (John, Richard,
> I'm kind of hoping you) would review the page to see if I've injected
> any errors. Furthermore, notwithstanding my attempt to improve the page,
> there remain many gaps in details in the page. I've added a large number
> of FIXMEs in the draft below, and would be happy if anyone can supply
> some content to fill any of the gaps.
>
> Cheers,
>
> Michael
>
> .\" Copyright (c) 1995 Michael Chastain (mec@shell.portal.com), 15 April 1995.
> .\" and Copyright (C) 2014 Michael Kerrisk <mtk.manpages@gmail.com>
> .\"
> .\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> .\" This is free documentation; you can redistribute it and/or
> .\" modify it under the terms of the GNU General Public License as
> .\" published by the Free Software Foundation; either version 2 of
> .\" the License, or (at your option) any later version.
> .\"
> .\" The GNU General Public License's references to "object code"
> .\" and "executables" are to be interpreted as the output of any
> .\" document formatting or typesetting system, including
> .\" intermediate and printed output.
> .\"
> .\" This manual is distributed in the hope that it will be useful,
> .\" but WITHOUT ANY WARRANTY; without even the implied warranty of
> .\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> .\" GNU General Public License for more details.
> .\"
> .\" You should have received a copy of the GNU General Public
> .\" License along with this manual; if not, see
> .\" <http://www.gnu.org/licenses/>.
> .\" %%%LICENSE_END
> .\"
> .\" Modified 1997-01-31 by Eric S. Raymond <esr@thyrsus.com>
> .\" Modified 1997-07-30 by Paul Slootman <paul@wurtel.demon.nl>
> .\" Modified 2004-05-27 by Michael Kerrisk <mtk.manpages@gmail.com>
> .\"
> .TH ADJTIMEX 2 2014-12-31 "Linux" "Linux Programmer's Manual"
> .SH NAME
> adjtimex \- tune kernel clock
> .SH SYNOPSIS
> .nf
> .BR "#define _BSD_SOURCE" "      /* See feature_test_macros(7) */"
> .B #include <sys/timex.h>
>
> .BI "int adjtimex(struct timex *" "buf" );
> .fi
> .SH DESCRIPTION
> Linux uses David L. Mills' clock adjustment algorithm (see RFC\ 5905).
> The system call
> .BR adjtimex ()
> reads and optionally sets adjustment parameters for this algorithm.
> It takes a pointer to a
> .I timex
> structure, updates kernel parameters from field values,
> and returns the same structure with current kernel values.
> This structure is declared as follows:
> .PP
> .in +4n
> .nf
> struct timex {
>     int  modes;      /* Mode selector */
>     long offset;     /* Time offset; nanoseconds, if STA_NANO
>                         status flag is set, otherwise microseconds */
>     long freq;       /* Frequency offset, in units of 2^-16 ppm
>                         (parts per million, see NOTES below) */
>     long maxerror;   /* Maximum error (microseconds) */
>     long esterror;   /* Estimated error (microseconds) */
>     int  status;     /* Clock command/status */
>     long constant;   /* PLL (phase-locked loop) time constant */
>     long precision;  /* Clock precision (microseconds, read-only) */
>     long tolerance;  /* Clock frequency tolerance (ppm, read-only) */
>     struct timeval time;
>                      /* Current time (read-only, except for
>                         ADJ_SETOFFSET); upon return, time.tv_usec
>                         contains nanoseconds, if STA_NANO status
>                         flag is set, otherwise microseconds */
>     long tick;       /* Microseconds between clock ticks */
>     long ppsfreq;    /* PPS (pulse per second) frequency (in units
>                         of 2^-16 ppm\-\-see NOTES, read-only) */
>     long jitter;     /* PPS jitter (read-only); nanoseconds, if
>                         STA_NANO status flag is set, otherwise
>                         microseconds */
>     int  shift;      /* PPS interval duration (seconds, read-only) */
>     long stabil;     /* PPS stability (2^-16 ppm\-\-see NOTES,
>                         read-only) */
>     long jitcnt;     /* PPS jitter limit exceeded (read-only) */
>     long calcnt;     /* PPS calibration intervals (read-only) */
>     long errcnt;     /* PPS calibration errors (read-only) */
>     long stbcnt;     /* PPS stability limit exceeded (read-only) */
>     int tai;         /* TAI offset, as set by previous ADJ_TAI
>                         operation (seconds, read-only,
>                         since Linux 2.6.26) */
>     /* Further padding bytes to allow for future expansion */
> };
> .fi
> .in
> .PP
> The
> .I modes
> field determines which parameters, if any, to set.
> It is a bit mask containing a
> .RI bitwise- or
> combination of zero or more of the following bits:
> .TP
> .BR ADJ_OFFSET
> Set time offset from
> .IR buf.offset .
> .TP
> .BR ADJ_FREQUENCY
> Set frequency offset from
> .IR buf.freq .
> .TP
> .BR ADJ_MAXERROR
> Set maximum time error from
> .IR buf.maxerror .
> .TP
> .BR ADJ_ESTERROR
> Set estimated time error from
> .IR buf.esterror .
> .TP
> .BR ADJ_STATUS
> Set clock status from
> .IR buf.status .
> .TP
> .BR ADJ_TIMECONST
> Set PLL time constant from
> .IR buf.constant .
> If the
> .B STA_NANO
> status flag (see below) is clear, the kernel adds 4 to this value.
> .TP
> .BR ADJ_SETOFFSET " (since Linux 2.6.29)"
> .\" commit 094aa1881fdc1b8889b442eb3511b31f3ec2b762
> .\" Author: Richard Cochran <richardcochran@gmail.com>
> Add
> .I buf.time
> to the current time.
> If
> .I buf.status
> includes the
> .B ADJ_NANO
> flag, then
> .I buf.time.tv_usec
> is interpreted as a nanosecond value;
> otherwise it is interpreted as microseconds.
> .TP
> .BR ADJ_MICRO " (since Linux 2.6.36)"
> .\" commit eea83d896e318bda54be2d2770d2c5d6668d11db
> .\" Author: Roman Zippel <zippel@linux-m68k.org>
> Select microsecond resolution.
> .TP
> .BR ADJ_NANO " (since Linux 2.6.36)"
> .\" commit eea83d896e318bda54be2d2770d2c5d6668d11db
> .\" Author: Roman Zippel <zippel@linux-m68k.org>
> Select nanosecond resolution.
> Only one of
> .BR ADJ_MICRO
> and
> .BR ADJ_NANO
> should be specified.
> .TP
> .BR ADJ_TAI " (since Linux 2.6.26)"
> .\" commit 153b5d054ac2d98ea0d86504884326b6777f683d
> Set TAI (Atomic International Time) offset from
> .IR buf->constant .

Minor nit: Elsewhere its buf.constant, not buf->constant.

>
> .BR ADJ_TAI
> should not be used in conjunction with
> .BR ADJ_TIMECONST ,
> since the latter mode also employs the
> .IR buf->constant

Same.


> field.
>
> For a complete explanation of TAI
> and the difference between TAI and UTC, see
> .UR http://www.bipm.org/en/bipm/tai/tai.html
> .I BIPM
> .UE
> .TP
> .BR ADJ_TICK
> Set tick value from
> .IR buf.tick .
> .PP
> Alternatively,
> .I modes
> can be specified as either of the following (multibit mask) values,
> in which case other bits should not be specified in
> .IR modes :
> .\" In general, the other bits are ignored, but ADJ_OFFSET_SINGLESHOT 0x8001
> .\" ORed with ADJ_NANO (0x2000) gives 0xa0001 == ADJ_OFFSET_SS_READ!!
> .TP
> .BR ADJ_OFFSET_SINGLESHOT
> .\" In user space, ADJ_OFFSET_SINGLESHOT is 0x8001
> .\" In kernel space it is 0x0001, and must be ANDed with ADJ_ADJTIME (0x8000)
> Old-fashioned
> .BR adjtime ():
> (gradually) adjust time by value specified in
> .IR buf.offset ,
> which specifies an adjustment in microseconds.
> .TP
> .BR ADJ_OFFSET_SS_READ " (functional since Linux 2.6.28)"
> .\" In user space, ADJ_OFFSET_SS_READ is 0xa001
> .\" In kernel space there is ADJ_OFFSET_READONLY (0x2000) anded with
> .\" ADJ_ADJTIME (0x8000) and ADJ_OFFSET_SINGLESHOT (0x0001) to give 0xa001)
> Return (in
> .BR buf.offset )
> the remaining amount of time to be adjusted after an earlier
> .BR ADJ_OFFSET_SINGLESHOT
> operation.
> This feature was added in Linux 2.6.24,
> .\" commit 52bfb36050c8529d9031d2c2513b281a360922ec
> but did not work correctly
> .\" commit 916c7a855174e3b53d182b97a26b2e27a29726a1
> until Linux 2.6.28.
> .PP
> Ordinary users are restricted to a value of either 0 or
> .B ADJ_OFFSET_SS_READ
> for
> .IR modes .
> Only the superuser may set any parameters.
>
> The
> .I buf.status
> field is a bit mask that is used to set and/or retrieve status
> bits associated with the NTP implementation.
> Some bits in the mask are both readable and settable,
> while others are read-only.
> .TP
> .BR STA_PLL
> Enable phase-locked loop (PLL) updates (read-write) via
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)


So for most of these, the following might be a useful reference:
http://www.slac.stanford.edu/comp/unix/package/rtems/src/ssrlApps/ntpNanoclock/api.htm


> .BR ADJ_OFFSET .
> .TP
> .BR STA_PPSFREQ
> Enable PPS freq discipline (read-write).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)
> .TP
> .BR STA_PPSTIME
> Enable PPS time discipline (read-write).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)

Adding Alexander Gordeev for additional comment on the PPS logic.


> .TP
> .BR STA_FLL
> Select frequency-locked loop (FLL) mode (read-write).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)
> .TP
> .BR STA_INS
> Insert leap second (read-write).
> .\" FIXME Is the following correct?
> .\"     Insert a leap second after the last second of the day.

Might be good to clarify that its the last second of the day UTC.


> .\"     That is, at 24:00:00, set the clock 1 second back, thus extending
> .\"     the last  minute of the day by one second.

So usually this is written as extending the day by one second,
which is represented as:
   23:59:59
   23:59:60
   00:00:00

But since posix cannot represent 23:59:60, we repeat the last second:
   23:59:59 + TIME_INS
   23:59:59 + TIME_OOP
   00:00:00 + TIME_WAIT



> .\"     Leap second insertion will occur each day, so long as this flag
> .\"     remains set.
> .TP
> .BR STA_DEL
> Delete leap second (read-write).
> .\" FIXME Is the following correct?
> .\"     Delete a leap second at the last second of the leap day.

I'd drop "leap day", since if STA_INS/DEL are set, they are applied to
the current day (UTC), and the kernel has no other frame of reference
for when a leap-day might be.

> .\"     That is, at 23:5:59, add one extra second to the clock.
> .\"     Leap second deletion will occur each day, so long as this flag
> .\"     remains set.

Similarly the progression here is:
   23:59:57 + TIME_DEL
   23:59:58 + TIME_DEL
   00:00:00 + TIME_WAIT


> .\" FIXME Does there need to be a statement that it is nonsensical to set
> .\"     to set both STA_INS and STA_DEL?
> .TP
> .BR STA_UNSYNC
> Clock unsynchronized (read-write).
> .TP
> .BR STA_FREQHOLD
> Hold frequency (read-write).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)


Normally adjustments made via ADJ_OFFSET, result in dampened freq
adjustments also being made. So a single call corrects the current
offset, but ass offsets in the same direction are made repeatedly, the
small freq adjustments will accumulate to fix the long term skew.

So this flag prevents the small frequency adjustment from being made
when correcting for an ADJ_OFFSET value.
(Though the link I added above suggests this isn't used in ntpv4).


> .TP
> .BR STA_PPSSIGNAL
> PPS signal present (read-only).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)
> .TP
> .BR STA_PPSJITTER
> PPS signal jitter exceeded (read-only).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)
> .TP
> .BR STA_PPSWANDER
> PPS signal wander exceeded (read-only).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)
> .TP
> .BR STA_PPSERROR
> PPS signal calibration error (read-only).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)
> .TP
> .BR STA_CLOCKERR
> Clock hardware fault (read-only).
> .\" FIXME Any pointer to further information about what this means?
> .\"       (It was not immediately obvious from a scan of the RFC, whether
> .\"       this is described in the RFC.)

I don't think we actually do anything with CLOCKERR. I think we check
for it in a few places, likely following the reference implementation,
but nothing is set to it.

> .TP
> .BR STA_NANO " (since Linux 2.6.26)"
> .\" commit eea83d896e318bda54be2d2770d2c5d6668d11db
> .\" Author: Roman Zippel <zippel@linux-m68k.org>
> Resolution (0 = microsecond, 1 = nanoseconds; read-only).
> Set via
> .BR ADJ_NANO ,
> cleared via
> .BR ADJ_MICRO .
> .TP
> .BR STA_MODE " (since Linux 2.6.26)"
> .\" commit eea83d896e318bda54be2d2770d2c5d6668d11db
> .\" Author: Roman Zippel <zippel@linux-m68k.org>
> Mode (0 = Phase Locked Loop, 1 = Frequency Locked Loop; read-only).
> .TP
> .BR STA_CLK " (since Linux 2.6.26)"
> .\" commit eea83d896e318bda54be2d2770d2c5d6668d11db
> .\" Author: Roman Zippel <zippel@linux-m68k.org>
> Clock source (0 = A, 1 = B; read-only).
> .\" FIXME It would be helpful to have some explanation of what
> .\"       "Clock source" is.

Similarly I don't think we use this at all. I'm guessing its here for
compatibility with the reference implementation.


> .PP
> Attempts to set read-only
> .I status
> bits are silently ignored.
> .SH RETURN VALUE
> On success,
> .BR adjtimex ()
> returns the clock state; that is, one of the following values:
> .TP 12
> .BR TIME_OK
> Clock synchronized.
> .TP
> .BR TIME_INS
> Insert leap second.
> .\" FIXME Is the following correct:
> .\"       Indicates that a leap second will be added at the end of the day
> .TP
> .BR TIME_DEL
> Delete leap second.
> .\" FIXME Is the following correct:
> .\"       Indicates that a leap second will be deleted at the end of the day
> .TP
> .BR TIME_OOP
> Leap second in progress.
> .\" FIXME Is the following correct:
> .\"       Indicates that we are currently in the middle of the leap second
> .\"       that is being added at the end of the day (as a result of STA_INS)
> .TP
> .BR TIME_WAIT
> Leap second has occurred.
> .\" FIXME Is the following correct:
> .\"       Indicates that a leap second has just been added or deleted
> .\"       during the previous second

So.. we actually hold TIME_WAIT until the next time ADJ_STATUS is set
to not include STA_INS or STA_DEL.


> .TP
> .BR TIME_ERROR
> Clock not synchronized.
> .\" FIXME Should more be said about how the TIME_ERROR state can occur?
> The symbolic name
> .B TIME_BAD
> is a synonym for
> .BR TIME_ERROR ,
> provided for backward compatibility.
> .PP
> On failure,
> .BR adjtimex ()
> returns \-1 and sets
> .IR errno .
> .SH ERRORS
> .TP
> .B EFAULT
> .I buf
> does not point to writable memory.
> .TP
> .B EINVAL
> An attempt was made to set
> .I buf.offset
> to a value outside the range \-131071 to +131071,
> or to set
> .I buf.status
> to a value other than those listed above,
> or to set
> .I buf.tick
> to a value outside the range
> .RB 900000/ HZ
> to
> .RB 1100000/ HZ ,
> where
> .B HZ
> is the system timer interrupt frequency.
> .TP
> .B EPERM
> .I buf.modes
> is neither 0 nor
> .BR ADJ_OFFSET_SS_READ ,
> and the caller does not have sufficient privilege.
> Under Linux, the
> .B CAP_SYS_TIME
> capability is required.
> .SH NOTES
> In struct
> .IR timex ,
> .IR freq ,
> .IR ppsfreq ,
> and
> .I stabil
> are ppm (parts per million) with a 16-bit fractional part,
> which means that a value of 1 in one of those fields
> actually means 2^-16 ppm, and 2^16=65536 is 1 ppm.
> This is the case for both input values (in the case of
> .IR freq )
> and output values.

Another possible thing to note, since with last weeks announcement
folks are starting to pay attention to leap-seconds again, is that
with both STA_INS/STA_DEL, the leap-second processing is done by the
kernel in timer context, thus it will take one tick into the second
for the leap second to be inserted or deleted.


> .SH CONFORMING TO
> .BR adjtimex ()
> is Linux-specific and should not be used in programs
> intended to be portable.
> See
> .BR adjtime (3)
> for a more portable, but less flexible,
> method of adjusting the system clock.

I don't know if you might want to reference ntp_adjtime() which is
probably the more portable interface that aligns closely here?
sys/timex.h seems to reference it but I don't see it in the man pages,
so maybe not...


thanks
-john
